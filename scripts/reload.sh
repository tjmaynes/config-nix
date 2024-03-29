#!/bin/bash

set -e

function main()
{
  git submodule update --remote

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    home-manager switch
  elif [[ "$OSTYPE" == "darwin"* ]] && [[ -n "$(command -v darwin-rebuild)" ]]; then
    darwin-rebuild switch
    brew update && brew upgrade
  else
    echo "Operating system not supported!"
    exit 1
  fi 
}

main
