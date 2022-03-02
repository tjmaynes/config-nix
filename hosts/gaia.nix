{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    hostname = "gaia";
    is_m1_mac = true;
  };

  imports = [ ./darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        cocoapods
        delta
        nodejs
        python39
        rustup
        yarn2nix
        yarn
      ];
    };
  };

  homebrew = {
    enable = lib.mkForce true;
    brewPrefix = "/opt/homebrew/bin";
    autoUpdate = true;
    cleanup = "zap";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ 
      "homebrew/cask" 
    ];
    casks = [
      "blender"
      "brave-browser"
      "drawio"
      "gimp"
      "imageoptim"
      "inkscape"
      "iterm2"
      "licecap"
      "macvim"
      "mpv"
      "obs"
      "selfcontrol"
      "spotify"
      "telegram"
      "vcv-rack"
      "visual-studio-code"
      "vmware-fusion"
    ];
    masApps = {
      Bitwarden = 1352778147;
      GarageBand = 682658836;
      Xcode = 497799835;
      DaisyDisk = 411643860;
      Keynote = 409183694;
      AnimoogZSynthesizer = 1586841361;
    };
  };

  system.stateVersion = 4;
}
