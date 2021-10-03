{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
   hostname = "gaia";
   is_m1_mac = true;
  };

  imports = [
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
      "gimp"
      "imageoptim"
      "inky"
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
    };
  };
}
