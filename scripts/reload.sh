#!/bin/bash

set -e

function main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    home-manager switch 
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    sudo chown -R root:staff /nix || true
    darwin-rebuild switch 
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
