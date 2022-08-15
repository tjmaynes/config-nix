{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "gaia"; };

  imports = [ ../modules/darwin ];

  system.stateVersion = 4;

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        go
        nodejs
        python39
        texlive.combined.scheme-full
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
      "brave-browser"
      "discord"
      "drawio"
      "gimp"
      "imageoptim"
      "goland"
      "iterm2"
      "ledger-live"
      "macvim"
      "mpv"
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
}
