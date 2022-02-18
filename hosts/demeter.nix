{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    hostname = "demeter";
  };

  imports = [
    ../nixos/configuration.nix
    ../darwin
  ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        alacritty
        bat
        cocoapods
        delta
        docker
        dog
        dotnet-sdk
        git
        gnupg
        go
        home-manager
        htop
        jq
        lsd
        mpv
        mutt
        nodejs-14_x
        procs
        python39
        ripgrep
        rustup
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
      "blender"
      "brave-browser"
      "drawio"
      "gimp"
      "imageoptim"
      "inkscape"
      "iterm2"
      "licecap"
      "macvim"
      "obs"
      "selfcontrol"
      "spotify"
      "telegram"
      "vcv-rack"
      "visual-studio-code"
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
}
