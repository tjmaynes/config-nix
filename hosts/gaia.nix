{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
  homebrewPath = "/opt/homebrew/bin";
in {
  imports = [
    <home-manager/nix-darwin>
    ../nixos/configuration.nix
    ../modules/darwin
  ];

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
    cleanup = "none";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ 
      "homebrew/cask" 
    ];
    casks = [
      "alacritty"
      "brave-browser"
      "discord"
      "imageoptim"
      "krisp"
      "macvim"
      "obs"
      "spotify"
      "steam"
      "telegram"
      "vcv-rack"
      "visual-studio-code"
    ];
    masApps = {
      Bitwarden = 1352778147;
      Xcode = 497799835;
      DaisyDisk = 411643860;
      Keynote = 409183694;
      Numbers = 409203825;
      "Affinity Photo" = 824183456;
      "Highland 2" = 1171820258;
    };
  };
}
