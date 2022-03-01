{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  imports = [ ../darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        cocoapods
        delta
        dotnet-sdk
        nodejs
        ruby
        yarn2nix
        yarn
      ];
    };
  };

  homebrew = {
    enable = lib.mkForce true;
    autoUpdate = true;
    cleanup = "zap";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ 
      "homebrew/cask" 
    ];
    brews = [
      "postgresql"
    ];
    casks = [
      "alacritty"
      "adoptopenjdk11"
      "google-chrome"
      "imageoptim"
      "intellij-idea"
      "iterm2"
      "krisp"
      "macvim"
      "microsoft-remote-desktop"
      "pop"
      "sf-symbols"
      "slack"
      "visual-studio-code"
      "vmware-fusion"
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
