{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "demeter"; };

  imports = [ ./darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        delta
        dotnet-sdk
        nodejs
        python39
        rustup
        vagrant
        packer
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
      "intellij-idea"
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
      AnimoogZSynthesizer = 1586841361;
      Bitwarden = 1352778147;
      DaisyDisk = 411643860;
      Keynote = 409183694;
      Xcode = 497799835;
    };
  };

  system.stateVersion = 4;
}
