{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  imports = [
    ../nixos/configuration.nix
    ../darwin
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
      "vmware-tanzu/tanzu"
    ];
    brews = [
      "tanzu-community-edition"
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
