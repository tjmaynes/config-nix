#!/bin/bash

function setup_environment()
{
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ $(uname -m) == 'arm64' ]]; then
      HOMEBREW_PATH="/opt/homebrew/bin"
    else
      HOMEBREW_PATH="/usr/local/bin"
    fi

    export PATH=$HOMEBREW_PATH:$PATH
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ANALYTICS=1
  else
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
  fi

  export PATH=$HOME/.npm-packages/bin:$PATH
  export NODE_PATH=$HOME/.npm-packages/lib/node_modules

  export GOPATH=$HOME/workspace/go
  export PATH=$GOPATH/bin:$PATH
}

function setup_docker() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ ! -d "/Applications/Docker.app" ]]; then
      echo "Installing Docker..."

      DOCKER_VERSION=$(uname -m)
      curl -O https://desktop.docker.com/mac/main/$DOCKER_VERSION/Docker.dmg

      hdiutil attach Docker.dmg
      cp -rf /Volumes/Docker/Docker.app /Applications && rm -rf Docker.dmg
    fi
  fi
}

function setup_vim() {
  if [[ -n "$(command -v vim)" ]]; then
    if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
      echo "Installing Vim Plug..."
      curl -Lo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    if [[ ! -d "$HOME/.vim/plugged" ]]; then
      echo "Installing Vim plugins..."
      vim +'PlugInstall --sync' +qa
    fi
  fi
}

function main()
{
  setup_environment

  setup_docker
  setup_vim

  . $HOME/.bash-fns.sh
}

main
