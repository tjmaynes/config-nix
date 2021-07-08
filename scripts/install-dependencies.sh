#!/bin/bash

set -e

function setup_macos() {
  export PATH=/usr/sbin:$PATH

  if [[ -z "$(command -v git)" ]]; then
    xcode-select --install
  fi

  softwareupdate --install-rosetta --agree-to-license

  compaudit | xargs chmod go-w
}

function install_nixos() {
  if [[ -z "$(command -v nix)" ]]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      sh <(curl -L https://nixos.org/nix/install) --daemon
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      setup_macos

      sh <(curl -L https://nixos.org/nix/install) --no-daemon --darwin-use-unencrypted-nix-store-volume

      source $HOME/.nix-profile/etc/profile.d/nix.sh
    else
      echo "Operating system not supported!"
      exit 1
    fi 
  fi
}

function symlink_config_directory() {
  if [ ! "$HOME/.config/nixpkgs" -ef "$(PWD)/hosts" ]; then
    (mkdir -p "$HOME/.config" || true) && ln -s "$(PWD)/profiles" "$HOME/.config/nixpkgs"
  fi
}

function install_home_manager() {
  symlink_config_directory

  if [[ -z "$(command -v home-manager)" ]]; then
    export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

    nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    nix-channel --update
  fi
}

function symlink_darwin_configuration() {
  if [ ! "$HOME/.nixpkgs/darwin-configuration.nix" -ef "$(PWD)/hosts/gaia.nix" ]; then
    (mkdir -p "$HOME/.nixpkgs" || true) && ln -s "$(PWD)/hosts/gaia.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
  fi
}

function install_nix_darwin() {
  symlink_darwin_configuration

  if [[ ! -f "$(pwd)/result/bin/darwin-installer" ]]; then
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  fi

  export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH
  echo "no" | ./result/bin/darwin-installer
}

function main() {
  install_nixos
  install_home_manager
  [[ "$OSTYPE" == "darwin"* ]] && install_nix_darwin
}

main
