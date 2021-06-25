{ config, lib, pkgs, ... }:

let home = builtins.getEnv "HOME";

in {
  programs.bash.interactiveShellInit = ''
    command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
  '';

  programs.zsh.shellInit = ''
    command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

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
    autoUpdate = true;
    cleanup = "zap";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ "homebrew/cask" ];
    casks = [
      "alacritty"
      "bitwarden"
      "brave-browser"
      "epic-games"
      "krisp"
      "intellij-idea"
      "iterm2"
      "macvim"
      "mpv"
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
