#!/bin/bash

set -e

export BASE_DIRECTORY=$1

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script"
    exit 1
  elif [[ -z "$(command -v 7z)" ]]; then
    echo "Please install '7z' before running this script"
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
  fi

  export ENVIRONMENT=development
  export TIMEZONE=America/Chicago
  export PUID=$UID
  export PGID=$(sudo id -g)

  export SERVER_HOST="$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
  export ADMIN_PORTAL_PORT=5000

  export MEDIA_DIRECTORY=${BASE_DIRECTORY}/media
  export BOOKS_DIRECTORY=${MEDIA_DIRECTORY}/Books
  export AUDIOBOOKS_DIRECTORY=${MEDIA_DIRECTORY}/Audiobooks
  export PODCASTS_DIRECTORY=${MEDIA_DIRECTORY}/Podcasts

  export JELLYFIN_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/jellyfin-server
  export JELLYFIN_PORT=8096
  export JELLYFIN_SERVER_URL="http://${SERVER_HOST}"

  export CALIBRE_WEB_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/calibre-web
  export CALIBRE_WEB_PORT=8083

  export GOGS_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/gogs-web
  export GOGS_PORT=3000
  export GOGS_SSH_PORT=222
  export GOGS_USER=gogs
  export GOGS_DATABASE=gogs
  export GOGS_DATABASE_PASSWORD=gogs
  export GOGS_DATABASE_PORT=5433
  export GOGS_DATABASE_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/gogs-db

  export HOME_ASSISTANT_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/home-assistant-web
  export HOME_ASSISTANT_PORT=8123

  export HOMER_WEB_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/homer-web
  export HOMER_WEB_PORT=8080

  export TAILSCALE_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/tailscale-agent

  export AUDIOBOOKSHELF_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/audiobookshelf-web
  export AUDIOBOOKSHELF_PORT=13378

  export PODGRAB_BASE_DIRECTORY=${BASE_DIRECTORY}/docker/podgrab-web
  export PODGRAB_PORT=8098
}

function download_and_install_jellyfin_plugin() {
  JELLYFIN_PLUGIN_NAME=$1
  JELLYFIN_PLUGIN_DLL_FILE=$2
  JELLYFIN_BOOKSHELF_PLUGIN_URL=$3

  if [[ ! -f "$JELLYFIN_BASE_DIRECTORY/config/data/plugins/configurations/$JELLYFIN_PLUGIN_DLL_FILE" ]]; then
    echo "Downloading and installing $JELLYFIN_PLUGIN_NAME..."

    curl -SL "$JELLYFIN_BOOKSHELF_PLUGIN_URL" --output $JELLYFIN_PLUGIN_NAME.zip
    7z x $JELLYFIN_PLUGIN_NAME.zip -otmp/$JELLYFIN_PLUGIN_NAME
    cp -rf tmp/$JELLYFIN_PLUGIN_NAME/* "$JELLYFIN_BASE_DIRECTORY/config/data/plugins/configurations"
    rm -rf tmp/$JELLYFIN_PLUGIN_NAME
  fi
}

function main() {
  check_requirements
  
  set_environment_variables

  ensure_directory_exists "$JELLYFIN_BASE_DIRECTORY/config"
  ensure_directory_exists "$JELLYFIN_BASE_DIRECTORY/plugins"
  ensure_directory_exists "$CALIBRE_WEB_BASE_DIRECTORY/config"
  ensure_directory_exists "$GOGS_BASE_DIRECTORY/data"
  ensure_directory_exists "$GOGS_DATABASE_BASE_DIRECTORY"
  ensure_directory_exists "$HOME_ASSISTANT_BASE_DIRECTORY/config"
  ensure_directory_exists "$HOMER_WEB_BASE_DIRECTORY/www/assets"
  ensure_directory_exists "$TAILSCALE_BASE_DIRECTORY/var/lib"
  ensure_directory_exists "$AUDIOBOOKSHELF_BASE_DIRECTORY/config"
  ensure_directory_exists "$AUDIOBOOKSHELF_BASE_DIRECTORY/metadata"
  ensure_directory_exists "$PODGRAB_BASE_DIRECTORY/config"

  ENCODED_SERVER_HOST="http:\/\/${SERVER_HOST}"
  sed \
     -e "s/%server-host%:%jellyfin-port%/${ENCODED_SERVER_HOST}:${JELLYFIN_PORT}/g" \
     -e "s/%server-host%:%calibre-web-port%/${ENCODED_SERVER_HOST}:${CALIBRE_WEB_PORT}/g" \
     -e "s/%server-host%:%home-assistant-port%/${ENCODED_SERVER_HOST}:${HOME_ASSISTANT_PORT}/g" \
     -e "s/%server-host%:%gogs-port%/${ENCODED_SERVER_HOST}:${GOGS_PORT}/g" \
     -e "s/%server-host%:%audiobookshelf-web-port%/${ENCODED_SERVER_HOST}:${AUDIOBOOKSHELF_PORT}/g" \
     -e "s/%server-host%:%admin-portal-port%/${ENCODED_SERVER_HOST}:${ADMIN_PORTAL_PORT}/g" \
     -e "s/%server-host%:%podgrab-port%/${ENCODED_SERVER_HOST}:${PODGRAB_PORT}/g" \
    data/homer.yml > "$HOMER_WEB_BASE_DIRECTORY/www/assets/config.yml"

  cp -f static/homer-logo.png "$HOMER_WEB_BASE_DIRECTORY/www/assets/logo.png"

  sudo -E docker-compose up -d

  sudo docker exec tailscale-agent tailscale up
}

main
