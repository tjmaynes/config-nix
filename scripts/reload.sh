#!/bin/bash

set -e

function main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    nixos-rebuild switch 
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "no" | ./result/bin/darwin-installer
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
