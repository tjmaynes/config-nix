{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "demeter"; };

  imports = [ ../modules/darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        ffmpeg
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
      "iterm2"
      "jellyfin-media-player"
      "ledger-live"
      "macvim"
      "mpv"
      "notion"
      "nvidia-geforce-now"
      "obs"
      "selfcontrol"
      "spotify"
      "sysex-librarian"
      "vcv-rack"
      "vagrant"
      "virtualbox"
      "vmware-fusion"
      "visual-studio-code"
      "zoom"
    ];
    masApps = {
      Amphetamine = 937984704;
      AnimoogZSynthesizer = 1586841361;
      Bitwarden = 1352778147;
      DaisyDisk = 411643860;
      Darkroom = 953286746;
      FinalCutPro = 424389933;
      Highland2 = 1171820258;
      Keynote = 409183694;
    };
  };

  system.stateVersion = 4;
}
