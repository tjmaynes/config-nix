{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  imports = [
    <home-manager/nix-darwin>
    ../nixos/configuration.nix
    ../modules/darwin
  ];

  programs.zsh.shellInit = ''
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_ANALYTICS=1

    export ANDROID_HOME=${home}/Library/Android/sdk
    export ANDROID_SDK_ROOT=${home}/Library/Android/sdk
    export ANDROID_AVD_HOME=${home}/.android/avd
    export PATH=$ANDROID_SDK_ROOT/tools/bin:$PATH

    if [[ ! -d "/Applications/Docker.app" ]]; then
      echo "Installing Docker..."
      arch_name="$(uname -m)"

      if [ "$arch_name" = "x86_64" ]; then
        curl -O https://desktop.docker.com/mac/stable/x86_64/Docker.dmg
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
    autoUpdate = true;
    cleanup = "none";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ 
      "homebrew/cask" 
    ];
    casks = [
      "adoptopenjdk11"
      "google-chrome"
      "imageoptim"
      "intellij-idea"
      "iterm2"
      "krisp"
      "macvim"
      "slack"
      "visual-studio-code"
      "webex"
      "zoom"
    ];
    masApps = {
      Bitwarden = 1352778147;
      Xcode = 497799835;
      Keynote = 409183694;
      Numbers = 409203825;
    };
  };
}
