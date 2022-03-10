{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "demeter"; };

  imports = [ ./darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        dotnet-sdk
        nodejs-16_x
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
    casks = [
      "brave-browser"
      "gimp"
      "imageoptim"
      "rider"
      "iterm2"
      "ledger-live"
      "mpv"
      "obs"
      "rider"
      "selfcontrol"
      "spotify"
      "vcv-rack"
      "visual-studio-code"
      "vmware-fusion"
    ];
    masApps = {
      Bitwarden = 1352778147;
      DaisyDisk = 411643860;
      Keynote = 409183694;
    };
  };

  system.stateVersion = 4;
}
