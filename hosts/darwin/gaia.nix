{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    is_m1_mac = true
  };

  imports = [
    <home-manager/nix-darwin>
    ../../nixos/configuration.nix
    ./common
  ];

  homebrew = {
    enable = lib.mkForce true;
    brewPrefix = "/opt/homebrew/bin";
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
      "flycut"
      "imageoptim"
      "macvim"
      "obs"
      "selfcontrol"
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
