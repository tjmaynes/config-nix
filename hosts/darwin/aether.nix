{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  imports = [
    <home-manager/nix-darwin>
    ../../nixos/configuration.nix
    ./common
  ];

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
      "flycut"
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