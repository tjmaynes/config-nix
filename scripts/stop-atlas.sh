#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi
}

function stop_program() {
  PROGRAM=$1  

  if [[ ! -d "hosts/atlas/$PROGRAM" ]]; then
    echo "$PROGRAM does not exist on path: hosts/atlas/$PROGRAM"
    exit 1
  fi

  pushd hosts/atlas/$PROGRAM
  docker compose down
  popd
}

function main() {
  check_requirements

  PROGRAMS=(gitea)
  for program in $PROGRAMS; do
    stop_program $program
  done
}

main
