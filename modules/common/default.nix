{ config, pkgs, ... }:

{
  imports = [ 
    ./settings.nix
    ./nixpkgs.nix
  ];

  networking.hostName = config.settings.hostname;
  time.timeZone = config.settings.timeZone;

  services.emacs.enable = true;

  programs.zsh.enable = true;
  programs.tmux.enable = true;
}
