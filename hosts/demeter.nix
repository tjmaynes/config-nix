{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    hostname = "demeter";
  };

  imports = [ ../darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        bat
        delta
        docker
        dog
        git
        gnupg
        htop
        jq
        lsd
        nodejs-14_x
        procs
        python39
        ripgrep
        tmux
        unzip
        vim
        yarn2nix
        yarn
        zip
        zsh
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
      "drawio"
      "gimp"
      "imageoptim"
      "intellij-idea"
      "iterm2"
      "macvim"
      "mpv"
      "obs"
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
      GarageBand = 682658836;
      Keynote = 409183694;
      Xcode = 497799835;
    };
  };
}
