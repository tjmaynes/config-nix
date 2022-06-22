#!/bin/bash

set -e

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIRECTORY="$(pwd)/backups/$TIMESTAMP"

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi
}

function create_directory_if_not_exists() {
  if [[ ! -d "$BACKUP_DIRECTORY/$1" ]]; then
    echo "Creating backup directory: $BACKUP_DIRECTORY/$1"
    mkdir -p "$BACKUP_DIRECTORY/$1"
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

function backup_gitea_volume() {
  print_preamble "gitea"

  docker exec -u git -i "gitea" \
    bash -c "/app/gitea/gitea dump --type tar.gz --file /tmp/gitea.tar.gz"

  docker cp gitea:/tmp/gitea.tar.gz "$BACKUP_DIRECTORY/gitea.tar.gz"

  print_postamble "gitea" 
}

function backup_gitea_db_volume() {
  print_preamble "gitea-db"

  docker exec -i "gitea-db" \
    bash -c "pg_dump -U $GITEA_USER $GITEA_DATABASE > dump.sql"

  docker cp gitea-db:/gitea-db.sql "$BACKUP_DIRECTORY/gitea/dump.sql"

  docker cp gitea-db:/var/lib/postgresql/data "$BACKUP_DIRECTORY/gitea/postgresql"

  tar -cf $BACKUP_DIRECTORY/gitea-db.tar.gz -C $BACKUP_DIRECTORY/gitea .

  rm -rf $BACKUP_DIRECTORY/gitea

  print_postamble "gitea-db" 
}

function backup_gitea() {
  if [[ -z "$GITEA_USER" ]]; then
    echo "Please set an environment variable for 'GITEA_USER' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE' before running this script"
    exit 1
  fi

  create_directory_if_not_exists "gitea"

  backup_gitea_volume
  backup_gitea_db_volume
}

function main() {
  check_requirements

  backup_gitea
}

main
