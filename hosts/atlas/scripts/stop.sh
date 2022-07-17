#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi
}

function main() {
  check_requirements

  docker compose down
}

main
