#!/bin/bash

set -e

HOST_NAME=$1
NIXOS_USERNAME=$2

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

  if [[ ! "$HOME/.config/nixpkgs" -ef "$(pwd)/hosts/darwin" ]]; then
    rm -rf "$HOME/.config/nixpkgs"
    (mkdir -p "$HOME/.config" || true) && ln -s "$(pwd)/hosts/darwin" "$HOME/.config/nixpkgs"
  fi

  if [[ ! "$(readlink $HOME/.nixpkgs/darwin-configuration.nix)" -ef "$(pwd)/hosts/darwin/$HOST_NAME.nix" ]]; then
    rm -rf "$HOME/.nixpkgs/darwin-configuration.nix"
    (mkdir -p "$HOME/.nixpkgs" || true) && ln -s "$(pwd)/hosts/darwin/$HOST_NAME.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
  fi

  if [[ -z "$(command -v home-manager)" ]]; then
    nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    nix-channel --update
  fi

  if [[ ! -f "$(pwd)/result/bin/darwin-installer" ]]; then
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  fi

  [[ -f "/etc/nix/nix.conf" ]] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup
  [[ -f "/etc/shells" ]] && sudo mv /etc/shells /etc/shells.backup

  ./result/bin/darwin-installer
}

function setup_nixos_based_host() {
  if [ "whoami" = "root" ]; then
    if ! id "$NIXOS_USERNAME" &>/dev/null; then
      adduser "$NIXOS_USERNAME"
      usermod -aG sudo "$NIXOS_USERNAME"
    fi

    su "$NIXOS_USERNAME"
  fi

  if [[ -z "$(command -v nix)" ]]; then
    sh <(curl -L https://nixos.org/nix/install) --daemon
  fi

  source $HOME/.nix-profile/etc/profile.d/nix.sh

  if [[ ! "$(readlink $HOME/.config/nixpkgs/home.nix)" -ef "$(pwd)/hosts/nixos/$HOST_NAME.nix" ]]; then
    rm -rf "$HOME/.config/nixpkgs"
    (mkdir -p "$HOME/.config/nixpkgs" || true) && ln -s "$(pwd)/hosts/nixos/$HOST_NAME.nix" "$HOME/.config/nixpkgs/home.nix"
  fi

  if [[ -z "$(command -v home-manager)" ]]; then
    nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    nix-channel --update
  fi
}

function main() {
  if [[ -z "$HOST_NAME" ]]; then
    echo "Please provide a HOST_NAME arg"
    exit 1
  elif [[ -z "$NIXOS_USERNAME" ]]; then
    echo "Please provide a NIXOS_USERNAME arg"
    exit 1
  fi

  if [ "$HOST_NAME" = "gaia" ] || [ "$HOST_NAME" = "aether" ]; then
    setup_darwin_based_host
  elif [ "$HOST_NAME" = "infinity" ]; then
    setup_nixos_based_host
  else
    echo "Host name $HOST_NAME has not been setup yet!"
    exit 1
  fi
}

main
