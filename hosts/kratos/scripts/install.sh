#!/bin/bash

set -e

export BASE_DIRECTORY=$1
export PLEX_CLAIM_TOKEN=$2

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script"
    exit 1
  fi
}

function ensure_directory_exists() {
  TARGET_DIRECTORY=$1

  if [[ ! -d "$TARGET_DIRECTORY" ]]; then
    echo "Creating $TARGET_DIRECTORY directory..."
    mkdir -p "$TARGET_DIRECTORY"
  fi
}

function set_environment_variables() {
  if [[ -z "$BASE_DIRECTORY" ]]; then
    echo "Please an environment variable for 'BASE_DIRECTORY' before running this script"
    exit 1
  elif [[ -z "$PLEX_CLAIM_TOKEN" ]]; then
    echo "Please an environment variable for 'PLEX_CLAIM_TOKEN' before running this script"
    exit 1
  fi

  export ENVIRONMENT=development
  export TIMEZONE=America/Chicago
  export PUID=$UID
  export PGID=$(sudo id -g)

  export MEDIA_DIRECTORY=${BASE_DIRECTORY}/media
  export BOOKS_DIRECTORY=${MEDIA_DIRECTORY}/Books

  export PLEX_HOSTNAME=Kratos
  export PLEX_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/plex-server

  export CALIBRE_WEB_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/calibre-web
  export CALIBRE_WEB_PORT=8083

  export GITEA_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/gitea-web
  export GITEA_PORT=3000
  export GITEA_SSH_PORT=222
  export GITEA_USER=gitea
  export GITEA_DATABASE=gitea
  export GITEA_DATABASE_PASSWORD=gitea
  export GITEA_DATABASE_PORT=5433
  export GITEA_DATABASE_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/gitea-db
}

function main() {
  check_requirements
  set_environment_variables

  ensure_directory_exists "$PLEX_BASE_DIRECTORY/config"
  ensure_directory_exists "$PLEX_BASE_DIRECTORY/transcode"
  ensure_directory_exists "$CALIBRE_WEB_BASE_DIRECTORY/config"

  ensure_directory_exists "$GITEA_BASE_DIRECTORY/data"
  ensure_directory_exists "$GITEA_DATABASE_BASE_DIRECTORY"

  if ! sudo cat /etc/timezone | grep "$TIMEZONE"; then
    echo "$TIMEZONE" >> /etc/timezone
  fi

  sudo -E docker-compose up -d
}

main
