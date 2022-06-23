#!/bin/bash

set -e

BACKUP_DIRECTORY="$(ls -td backups/*/ | head -1)"

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
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
  BACKUP_NAME=$1

  rm -rf $BACKUP_DIRECTORY/$BACKUP_NAME
  mkdir -p $BACKUP_DIRECTORY/$BACKUP_NAME

  tar -xf $BACKUP_DIRECTORY/$BACKUP_NAME.tar.gz -C $BACKUP_DIRECTORY/$BACKUP_NAME
}

function restore_gitea() {
  print_preamble "gitea"

  if [[ -z "$GITEA_USER" ]]; then
    echo "Please set an environment variable for 'GITEA_USER' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE' before running this script"
    exit 1
  fi

  unpack_tarred_backup "gitea"

  docker cp "$BACKUP_DIRECTORY/gitea/data" gitea:/tmp/backup/data

  docker exec -i "gitea" \
    bash -c "cp -rf /tmp/backup/data /data/gitea"

  if [[ -d "$BACKUP_DIRECTORY/gitea/repos" ]]; then
    docker cp "$BACKUP_DIRECTORY/gitea/repos" gitea:/tmp/backup/repos

    docker exec -i "gitea" \
      bash -c "cp -rf /tmp/backup/repos /data/git/repositories"
  fi

  docker exec -i "gitea" \
    bash -c "chown -R git:git /data"

  docker exec -u git -i "gitea" \
    bash -c "/usr/local/bin/gitea -c '/data/gitea/conf/app.ini' admin regenerate hooks"

  print_postamble "gitea" 

  print_preamble "gitea-db"

  docker cp "$BACKUP_DIRECTORY/gitea/gitea-db.sql" gitea-db:/tmp

  docker exec -i "gitea-db" \
    bash -c "psql -U $GITEA_USER -d $GITEA_DATABASE --set ON_ERROR_STOP=on < /tmp/gitea-db.sql"

  print_postamble "gitea-db" 
}

function main() {
  check_requirements

  restore_gitea
}

main
