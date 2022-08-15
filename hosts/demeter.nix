{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "demeter"; };

  imports = [ ../modules/darwin ];

  system.stateVersion = 4;

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        texlive.combined.scheme-full
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
      "calibre"
      "discord"
      "iterm2"
      "ledger-live"
      "macvim"
      "mpv"
      "notion"
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
}
