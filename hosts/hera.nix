{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    hostname = "hera";
    is_apple_silicon = true;
    git_username = "tjmaynes-indebted";
  };

  imports = [ ../modules/darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      stateVersion = "22.05";

      packages = with pkgs; [
        awscli2
        go
        nodejs
        python39
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
      "jamesjoshuahill/tap"
    ];
    brews = [
      "jamesjoshuahill/tap/git-co-author"
    ];
    casks = [
      "drawio"
      "goland"
      "google-chrome"
      "krisp"
      "iterm2"
      "macvim"
      "tailscale"
      "tuple"
      "visual-studio-code"
      "vmware-fusion"
    ];
  };
}
