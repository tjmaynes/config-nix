#!/bin/bash

set -e

function main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    nixos-rebuild switch 
  elif [[ "$OSTYPE" == "darwin"* ]] && [[ -z "$(command -z darwin-rebuild)" ]]; then
    darwin-rebuild switch
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
