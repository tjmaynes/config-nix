{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
  homebrewPath = "/opt/homebrew/bin";
in {
  programs.zsh.shellInit = ''
    export PATH=${homebrewPath}:$PATH
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ANALYTICS=1

    if [[ ! -d "/Applications/Docker.app" ]]; then
      echo "Installing Docker..."
      arch_name="$(uname -m)"

      if [ "$arch_name" = "arm64" ]; then
         curl -O https://desktop.docker.com/mac/stable/arm64/Docker.dmg
      else
         echo "Unknown architecture detected: $arch_name"
         exit 1
      fi

      hdiutil attach Docker.dmg
      cp -rf /Volumes/Docker/Docker.app /Applications
      rm -rf Docker.dmg

      open /Applications/Docker.app
    fi
  '';

  homebrew = {
    enable = lib.mkForce true;
    brewPrefix = homebrewPath;
    autoUpdate = true;
    cleanup = "zap";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ 
      "homebrew/cask" 
      "AdoptOpenJDK/openjdk"
    ];
    casks = [
      "adoptopenjdk11"
      "alacritty"
      "brave-browser"
      "drawio"
      "epic-games"
      "krisp"
      "intellij-idea"
      "iterm2"
      "macvim"
      "obs"
      "slack"
      "spotify"
      "visual-studio-code"
      "zoom"
    ];
    masApps = {
      Bitwarden = 1352778147;
      Xcode = 497799835;
      DaisyDisk = 411643860;
      Keynote = 409183694;
      "Highland 2" = 1171820258;
    };
  };
}
