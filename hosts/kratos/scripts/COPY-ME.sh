#!/bin/bash

set -e

export BASE_DIRECTORY=$1

function main() {
  if [[ -d "config" ]]; then
	  sudo rm -rf config
  fi

  curl -SL https://github.com/tjmaynes/config/archive/master.tar.gz | tar xz
  mv config-main config

  pushd config/hosts/kratos
    ./scripts/install.sh "$BASE_DIRECTORY"
  popd
}

main
