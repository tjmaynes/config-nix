{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
  homebrewPath = if config.settings.is_m1_mac then "/opt/homebrew/bin" else "/usr/local/bin";
  dockerVersion = if config.settings.is_m1_mac then "arm64" else "amd64";
in {
  programs.zsh.shellInit = ''
    export PATH=${homebrewPath}:$PATH
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ANALYTICS=1

    export PATH=$HOME/.npm-packages/bin:$PATH
    export NODE_PATH=$HOME/.npm-packages/lib/node_modules
    export DOTNET_CLI_TELEMETRY_OPTOUT=true

    if [[ -n "$(command -v dotnet)" ]]; then
      export PATH=${home}/.dotnet/tools:$PATH
      export DOTNET_PATH=$(nix-store -q --references $(which dotnet) | grep dotnet | head)
    fi

    if [[ -n "$(command -v cargo)" ]]; then
      export PATH=${home}/.cargo/bin:$PATH
    fi

    function setup_docker() {
      if [[ ! -d "/Applications/Docker.app" ]]; then
        echo "Installing Docker..."
        curl -O https://desktop.docker.com/mac/main/${dockerVersion}/Docker.dmg

        hdiutil attach Docker.dmg
        cp -rf /Volumes/Docker/Docker.app /Applications && rm -rf Docker.dmg
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

    function pclone() {
      GIT_REPO=tjmaynes/$1

      if [[ -z "$1" ]]; then
        echo "Please provide a git repo as arg 1"  
      elif [[ ! -d "$WORKSPACE_DIR/$GIT_REPO" ]]; then
        git clone git@github.com:$GIT_REPO.git $WORKSPACE_DIR/$GIT_REPO

        [[ -d "$WORKSPACE_DIR/$GIT_REPO" ]] && cd $WORKSPACE_DIR/$GIT_REPO
      fi
    }

    setup_docker
    setup_vim
  '';
}
