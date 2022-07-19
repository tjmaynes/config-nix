{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    hostname = "hera";
    is_m1_mac = true;
  };

  imports = [ ../modules/darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        go
        nodejs
        python39
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
      "google-chrome"
      "drawio"
      "goland"
      "iterm2"
      "macvim"
      "obs"
      "visual-studio-code"
      "vmware-fusion"
      "zoom"
    ];
    masApps = {
      Keynote = 409183694;
      Bitwarden = 1352778147;
    };
  };

  system.stateVersion = 4;
}
