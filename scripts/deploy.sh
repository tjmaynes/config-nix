#!/bin/bash

set -e

HOST=$1

function setup_gaia() {
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

  export PATH=/opt/homebrew/bin:$PATH

  if [[ -z "$(command -v brew)" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -z "$(command -v nix)" ]]; then
    sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
  fi

  if [[ ! "$HOME/.config/nixpkgs" -ef "$(pwd)/hosts" ]]; then
    (mkdir -p "$HOME/.config" || true) && ln -s "$(pwd)/hosts" "$HOME/.config/nixpkgs"
  fi

  if [[ -z "$(command -v home-manager)" ]]; then
    nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    nix-channel --update
  fi

  if [[ ! "$(readlink $HOME/.nixpkgs/darwin-configuration.nix)" -ef "$(pwd)/hosts/gaia.nix" ]]; then
    (mkdir -p "$HOME/.nixpkgs" || true) && ln -s "$(pwd)/hosts/gaia.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
  fi

  if [[ ! -f "$(pwd)/result/bin/darwin-installer" ]]; then
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  fi

  [[ -f "/etc/nix/nix.conf" ]] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup
  [[ -f "/etc/shells" ]] && sudo mv /etc/shells /etc/shells.backup

  ./result/bin/darwin-installer
}

function main() {
  setup_$HOST
}

main
