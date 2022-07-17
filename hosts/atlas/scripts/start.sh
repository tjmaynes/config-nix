#!/bin/bash

set -e

function check_env_var_exists() {
  if [[ -z "$2" ]]; then
    echo "Please set an environment variable for '$1' before running this script"
    exit 1
  fi
}

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi

  check_env_var_exists "BACKUP_DIRECTORY" "$BACKUP_DIRECTORY"
  check_env_var_exists "TIMEZONE" "$TIMEZONE"
  check_env_var_exists "GITEA_PORT" "$GITEA_PORT"
  check_env_var_exists "GITEA_BASE_DIRECTORY" "$GITEA_BASE_DIRECTORY"
  check_env_var_exists "GITEA_URL" "$GITEA_URL"
  check_env_var_exists "GITEA_USER" "$GITEA_USER"
  check_env_var_exists "GITEA_DATABASE" "$GITEA_DATABASE"
  check_env_var_exists "GITEA_DATABASE_PASSWORD" "$GITEA_DATABASE_PASSWORD"
  check_env_var_exists "GITEA_DATABASE_PORT" "$GITEA_DATABASE_PORT"
  check_env_var_exists "GITEA_DATABASE_BASE_DIRECTORY" "$GITEA_DATABASE_BASE_DIRECTORY"
  check_env_var_exists "JELLYFIN_BASE_DIRECTORY" "$JELLYFIN_BASE_DIRECTORY"
  check_env_var_exists "JELLYFIN_MEDIA_DIRECTORY" "$JELLYFIN_MEDIA_DIRECTORY"
  check_env_var_exists "JELLYFIN_SERVER_URL" "$JELLYFIN_SERVER_URL"
  check_env_var_exists "TINYMEDIAMANAGER_PORT" "$TINYMEDIAMANAGER_PORT"
  check_env_var_exists "TINYMEDIAMANAGER_BASE_DIRECTORY" "$TINYMEDIAMANAGER_BASE_DIRECTORY"
  check_env_var_exists "TINYMEDIAMANAGER_MOVIES_DIRECTORY" "$TINYMEDIAMANAGER_MOVIES_DIRECTORY"
  check_env_var_exists "TINYMEDIAMANAGER_TVSHOWS_DIRECTORY" "$TINYMEDIAMANAGER_TVSHOWS_DIRECTORY"
  check_env_var_exists "PORTAINER_PORT" "$PORTAINER_PORT"
  check_env_var_exists "PORTAINER_BASE_DIRECTORY" "$PORTAINER_BASE_DIRECTORY"
  check_env_var_exists "FLAME_PORT" "$FLAME_PORT"
  check_env_var_exists "FLAME_BASE_DIRECTORY" "$FLAME_BASE_DIRECTORY"
  check_env_var_exists "FLAME_PASSWORD" "$FLAME_PASSWORD"
}

function main() {
  check_requirements

  docker compose up -d
}

main
