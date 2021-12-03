{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  imports = [
    ../nixos/configuration.nix
    ../darwin
  ];

  home-manager.users.${config.settings.username} = {
    home = {
      packages = with pkgs; [
        alacritty
        bat
        cmus
        delta
        docker
        dog
        ffmpeg
        git
        gnupg
        home-manager
        htop
        jq
        lsd
        mpv
        mutt
        nodejs-14_x
        procs
        ripgrep
        ruby
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
    cleanup = "none";
    extraConfig = ''
      cask_args appdir: "${home}/Applications"
      cask_args require_sha: true
    '';
    taps = [ 
      "homebrew/cask" 
    ];
    casks = [
      "adoptopenjdk11"
      "google-chrome"
      "imageoptim"
      "intellij-idea"
      "iterm2"
      "krisp"
      "macvim"
      "pop"
      "slack"
      "visual-studio-code"
      "webex"
      "zoom"
    ];
    masApps = {
      Bitwarden = 1352778147;
      Xcode = 497799835;
      Keynote = 409183694;
      Numbers = 409203825;
    };
  };
}
