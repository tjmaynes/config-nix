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

  echo "Restoring '$CONTAINER_NAME' container volume from backup: $BACKUP_DIRECTORY"
}

function print_postamble() {
  CONTAINER_NAME=$1

  echo "Finished restoring '$CONTAINER_NAME'"
}

function unpack_tarred_backup() {
  TAR_BACKUP_LOCATION=$1
  TARGET_BACKUP_DIRECTORY=$2

  if [[ -f "$TAR_BACKUP_LOCATION" ]]; then
    rm -rf $TARGET_BACKUP_DIRECTORY && mkdir -p $TARGET_BACKUP_DIRECTORY

    tar -xf $TAR_BACKUP_LOCATION -C $TARGET_BACKUP_DIRECTORY
  fi
}

function wait_until_postgres_is_up() {
  RETRIES=5

  until docker exec -i "$1" bash -c "psql -U $2 -c \"select 1\"" > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
    echo "Waiting for postgres server, $((RETRIES--)) remaining attempts..."
    sleep 1
  done
}

function restore_gitea() {
  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No gitea backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ ! -d "$BACKUP_DIRECTORY/gitea" ]]; then
    echo "No gitea backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ -z "$GITEA_USER" ]]; then
    echo "Please set an environment variable for 'GITEA_USER' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE' before running this script"
    exit 1
  fi

  print_preamble "gitea-db" "$GITEA_USER"

  wait_until_postgres_is_up "gitea-db"

  docker cp "$BACKUP_DIRECTORY/gitea/gitea-db.sql" gitea-db:/tmp

  docker exec -i "gitea-db" \
    bash -c "psql -U $GITEA_USER -d $GITEA_DATABASE < /tmp/gitea-db.sql"

  print_postamble "gitea-db" 

  print_preamble "gitea-web"

  docker cp "$BACKUP_DIRECTORY/gitea/data" gitea-web:/tmp/backup-data

  docker exec -i "gitea-web" \
    bash -c "cp -rf /tmp/backup-data /data/gitea"

  if [[ -d "$BACKUP_DIRECTORY/gitea/repos" ]]; then
    docker cp "$BACKUP_DIRECTORY/gitea/repos" gitea-web:/tmp/backup-repos

    docker exec -i "gitea-web" \
      bash -c "cp -rf /tmp/backup-repos /data/git/repositories"
  fi

  docker exec -i "gitea-web" \
    bash -c "chown -R git:git /data"

  docker exec -u git -i "gitea-web" \
    bash -c "/usr/local/bin/gitea -c '/data/gitea/conf/app.ini' admin regenerate hooks" || true

  print_postamble "gitea-web" 
}

function restore_jellyfin() {
  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No gitea backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ -z "$JELLYFIN_BASE_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_BASE_DIRECTORY' before running this script"
    exit 1
  fi

  print_preamble "jellyfin-server"

  sudo cp -rf $BACKUP_DIRECTORY/jellyfin $JELLYFIN_BASE_DIRECTORY

  print_postamble "jellyfin-server"
}

function restore_tinyMediaManager() {
  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No gitea backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ -z "$TINYMEDIAMANAGER_BASE_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'TINYMEDIAMANAGER_BASE_DIRECTORY' before running this script"
    exit 1
  fi

  print_preamble "tinyMediaManager-web"

  sudo cp -rf $BACKUP_DIRECTORY/tinyMediaManager $TINYMEDIAMANAGER_BASE_DIRECTORY

  print_postamble "tinyMediaManager-web"
}

function restore_portainer() {
  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No gitea backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ -z "$PORTAINER_BASE_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'PORTAINER_BASE_DIRECTORY' before running this script"
    exit 1
  fi

  print_preamble "portainer-web"

  sudo cp -rf $BACKUP_DIRECTORY/portainer $PORTAINER_BASE_DIRECTORY

  print_postamble "portainer-web"
}

function restore_flame() {
  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No gitea backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ -z "$FLAME_BASE_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'FLAME_BASE_DIRECTORY' before running this script"
    exit 1
  fi

  print_preamble "flame-web"

  sudo cp -rf $BACKUP_DIRECTORY/flame $FLAME_BASE_DIRECTORY

  print_postamble "flame-web"
}

function main() {
  check_requirements

  PROGRAMS=(gitea jellyfin tinyMediaManager portainer flame)
  for program in ${PROGRAMS[@]}; do
    LATEST_TAR_BACKUP_LOCATION="$(ls -td $BACKUP_DIRECTORY/$program-* | head -1)"
    
    if [[ -f "$LATEST_TAR_BACKUP_LOCATION" ]]; then
      unpack_tarred_backup "$LATEST_TAR_BACKUP_LOCATION" "$BACKUP_DIRECTORY/$program"

      restore_$program

      rm -rf $BACKUP_DIRECTORY/$program
    fi
  done
}

main
