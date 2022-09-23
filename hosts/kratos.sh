#!/usr/bin/env bash

set -e

function install_packages() {
  apt update && apt upgrade -y

  apt install -y --no-install-recommends \
    bat \
    curl \
    delta \
    emacs \
    ffmpeg \
    git \
    make \
    gnupg \
    htop \
    jq \
    pandoc \
    ripgrep \
    stow \
    tmux \
    unzip \
    vim \
    yarn \
    zip \
    zsh

  echo ""
}

function install_zprezto() {
  if [[ ! -d "$HOME/.zprezto" ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
  fi
}

function install_asdf() {
  if [[ ! -d "$HOME/.asdf" ]]; then
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.10.2
  fi

  source "$HOME/.asdf/asdf.sh"

  asdf plugin-add golang https://github.com/kennyp/asdf-golang.git || true
  asdf install golang 1.19.1
  
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
  asdf install nodejs 18.9.0
}

function setup_dotfiles() {
  cd dotfiles && make setup
}

function main() {
  install_packages
  install_zprezto
  install_asdf

  setup_dotfiles
}

main