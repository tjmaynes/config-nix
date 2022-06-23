#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No backup directories do not exist in the file system. Nothing to restore!"
    exit 1
  fi
}

function print_preamble() {
  CONTAINER_NAME=$1

  echo "Backing up '$CONTAINER_NAME' container volume..."
}

function print_postamble() {
  CONTAINER_NAME=$1

  echo "Finished backing up: '$CONTAINER_NAME'"
}

function backup_gitea() {
  print_preamble "gitea"

  if [[ -z "$GITEA_USER" ]]; then
    echo "Please set an environment variable for 'GITEA_USER' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE' before running this script"
    exit 1
  fi

  docker exec -u git -i "gitea" \
    bash -c "/app/gitea/gitea dump --type tar.gz --file /tmp/gitea.tar.gz"

  docker cp gitea:/tmp/gitea.tar.gz "$BACKUP_DIRECTORY/gitea.tar.gz"

  print_postamble "gitea" 
}

function main() {
  check_requirements
  
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  BACKUP_DIRECTORY="$BACKUP_DIRECTORY/$TIMESTAMP"

  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "Creating backup directory: $BACKUP_DIRECTORY"
    mkdir -p "$BACKUP_DIRECTORY"
  fi

  backup_gitea
}

main
