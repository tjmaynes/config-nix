{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "demeter"; };

  imports = [ ./darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        ffmpeg
        go
        nodejs-14_x
        python39
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
      "cmus"
    ];
    casks = [
      "brave-browser"
      "discord"
      "drawio"
      "gimp"
      "imageoptim"
      "intellij-idea"
      "iterm2"
      "ledger-live"
      "macvim"
      "mpv"
      "nvidia-geforce-now"
      "obs"
      "steam"
      "selfcontrol"
      "spotify"
      "sysex-librarian"
      "vcv-rack"
      "visual-studio-code"
      "vmware-fusion"
      "xnviewmp"
      "zoom"
    ];
    masApps = {
      FinalCutPro = 424389933;
      Highland2 = 1171820258;
      Keynote = 409183694;
      AnimoogZSynthesizer = 1586841361;
      Bitwarden = 1352778147;
      DaisyDisk = 411643860;
    };
  };

  system.stateVersion = 4;
}
