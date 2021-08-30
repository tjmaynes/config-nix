#!/bin/bash

set -e

HOST_NAME=$1

function set_homebrew_path() {
  if [ "$(uname -m)" = "arm64" ]; then
    export PATH=/opt/homebrew/bin:$PATH
  else
    export PATH=/usr/local/bin:$PATH
  fi
}

function setup_darwin_based_host() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Please run this script on a Darwin-based machine"
    exit 1
  fi

  export PATH=/usr/sbin:$PATH
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH

  if [[ -z "$(command -v git)" ]]; then
    xcode-select --install
  fi

  set_homebrew_path

  if [[ -z "$(command -v brew)" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -z "$(command -v nix)" ]]; then
    sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
  fi

  if [[ ! "$HOME/.config/nixpkgs" -ef "$(pwd)/hosts" ]]; then
    rm -rf "$HOME/.config/nixpkgs"
    (mkdir -p "$HOME/.config" || true) && ln -s "$(pwd)/hosts" "$HOME/.config/nixpkgs"
  fi

  if [[ -z "$(command -v home-manager)" ]]; then
    nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    nix-channel --update
  fi

  if [[ ! "$(readlink $HOME/.nixpkgs/darwin-configuration.nix)" -ef "$(pwd)/hosts/$HOST_NAME.nix" ]]; then
    rm -rf "$HOME/.nixpkgs/darwin-configuration.nix"
    (mkdir -p "$HOME/.nixpkgs" || true) && ln -s "$(pwd)/hosts/$HOST_NAME.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
  fi

  if [[ ! -f "$(pwd)/result/bin/darwin-installer" ]]; then
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  fi

  [[ -f "/etc/nix/nix.conf" ]] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup
  [[ -f "/etc/shells" ]] && sudo mv /etc/shells /etc/shells.backup

  ./result/bin/darwin-installer
}

function main() {
  if [ "$HOST_NAME" = "gaia" ] || [ "$HOST_NAME" = "aether" ]; then
    setup_darwin_based_host
  fi
}

main
