#!/bin/bash

set -e

function main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    nixos-rebuild switch 
  elif [[ "$OSTYPE" == "darwin"* ]] && [[ -n "$(command -v darwin-rebuild)" ]]; then
    darwin-rebuild switch
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
