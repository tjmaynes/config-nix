{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
   hostname = "gaia";
   is_m1_mac = true;
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
        delta
        docker
        dog
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
      "alacritty"
      "blender"
      "brave-browser"
      "gimp"
      "godot"
      "imageoptim"
      "inkscape"
      "intellij-idea"
      "iterm2"
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
    };
  };
}
