#!/bin/bash

set -e

function main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    home-manager switch 
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # TODO: Replace darwin-installer with darwin-rebuild switch
    # Issue: error: file 'darwin' was not found in the Nix search path (add it using $NIX_PATH or -I)
    ./result/bin/darwin-installer
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
