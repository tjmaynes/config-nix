{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = {
    hostname = "hera";
    is_apple_silicon = true;
  };

  imports = [ ../modules/darwin ];

  home-manager.users.${config.settings.username} = {
    home = {
      stateVersion = "22.05";

      packages = with pkgs; [
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
    ];
    casks = [
      "google-chrome"
      "krisp"
      "drawio"
      "goland"
      "iterm2"
      "macvim"
      "tuple"
      "visual-studio-code"
      "vmware-fusion"
    ];
  };
}
