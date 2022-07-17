#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ -z "$BACKUP_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'BACKUP_DIRECTORY'"
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

function backup_dir() {
  PROGRAM_NAME=$1
  BASE_DIRECTORY=$2
  TARGET_LOCATION=$3

  pushd $BASE_DIRECTORY
    tar -czvf $BACKUP_DIRECTORY/$PROGRAM_NAME-$BACKUP_TIMESTAMP.tar.gz $TARGET_LOCATION
  popd
}

function backup_gitea() {
  print_preamble "gitea-web"

  docker exec -u git -i "gitea-web" \
    bash -c "/app/gitea/gitea dump --type tar.gz --file /tmp/gitea.tar.gz"

  docker cp gitea-web:/tmp/gitea.tar.gz $BACKUP_DIRECTORY/gitea-$BACKUP_TIMESTAMP.tar.gz

  print_postamble "gitea-web"
}

function backup_jellyfin() {
  if [[ -z "$JELLYFIN_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'JELLYFIN_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "jellyfin-server"
  backup_dir "jellyfin" "$(dirname $JELLYFIN_BASE_DIRECTORY)" "jellyfin/config" 
  print_postamble "jellyfin-server"
}

function backup_tinyMediaManager() {
  if [[ -z "$TINYMEDIAMANAGER_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'TINYMEDIAMANAGER_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "tinyMediaManager-web"
  backup_dir "tinyMediaManager" "$(dirname $TINYMEDIAMANAGER_BASE_DIRECTORY)" "tinyMediaManager/data"  
  print_postamble "tinyMediaManager-web"
}

function backup_portainer() {
  if [[ -z "$PORTAINER_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'PORTAINER_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "portainer-web"
  backup_dir "portainer" "$(dirname $PORTAINER_BASE_DIRECTORY)" "portainer/data" 
  print_postamble "portainer-web"
}

function backup_flame() {
  if [[ -z "$FLAME_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'FLAME_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "flame-web"
  backup_dir "flame" "$(dirname $FLAME_BASE_DIRECTORY)" "flame/data"
  print_postamble "flame-web"
}

function main() {
  check_requirements

  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "Creating backup directory: $BACKUP_DIRECTORY"
    mkdir -p "$BACKUP_DIRECTORY"
  fi

  BACKUP_TIMESTAMP=$(date +%Y%m%d-%H%M%S)

  PROGRAMS=(gitea jellyfin tinyMediaManager portainer flame)
  for program in ${PROGRAMS[@]}; do
    backup_$program
  done
}

main
