#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi
}

function install_program() {
  PROGRAM=$1  

  if [[ ! -d "$(pwd)/$PROGRAM" ]]; then
    echo "$PROGRAM does not exist on path: $(pwd)/$PROGRAM"
    exit 1
  elif [[ ! -f "$(pwd)/$PROGRAM/docker-compose.yml" ]]; then
    echo "$PROGRAM does not contain docker-compose.yml on path: $(pwd)/$PROGRAM"
    exit 1
  fi

  pushd $(pwd)/$PROGRAM
  docker compose up -d
  popd
}

function main() {
  check_requirements

  PROGRAMS=(gitea)
  for program in $PROGRAMS; do
    install_program $program
  done
}

main
