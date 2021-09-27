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
  '';
}
