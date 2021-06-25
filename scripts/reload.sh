#!/bin/bash

set -e

function main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    home-manager switch 
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    sudo rm -rf $HOME/.nix-defexpr/channels && mkdir -p $HOME/.nix-defexpr/channels
    sudo chown -R root:staff /nix || true
    sudo -i nix-channel --update
    darwin-rebuild switch 
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
