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

    export ANDROID_HOME=${home}/Library/Android/sdk
    export ANDROID_SDK_ROOT=${home}/Library/Android/sdk
    export ANDROID_AVD_HOME=${home}/.android/avd
    export PATH=$ANDROID_SDK_ROOT/tools/bin:$PATH

    if [[ ! -d "/Applications/Docker.app" ]]; then
      echo "Installing Docker..."
      curl -O https://desktop.docker.com/mac/main/${dockerVersion}/Docker.dmg

      hdiutil attach Docker.dmg
      cp -rf /Volumes/Docker/Docker.app /Applications && rm -rf Docker.dmg
    fi

    if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
      echo "Installing Vim Plug..."
      curl -Lo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    if [[ ! -d "$HOME/.vim/plugged" ]]; then
      echo "Installing Vim plugins..."
      vim +'PlugInstall --sync' +qa
    fi

    function pclone() {
      GIT_REPO=tjmaynes/$1

      if [[ -z "$GIT_REPO" ]]; then
        echo "Please provide a git repo as arg 1"  
      elif [[ ! -d "$WORKSPACE_DIR/$GIT_REPO" ]]; then
        git clone git@github.com:$GIT_REPO.git $WORKSPACE_DIR/$GIT_REPO
      fi

      [[ -d "$WORKSPACE_DIR/$GIT_REPO" ]] && cd $WORKSPACE_DIR/$GIT_REPO
    }

    export PATH=${home}/.cargo/bin:$PATH
    export PATH=${home}/go/bin:$PATH
  '';
}
