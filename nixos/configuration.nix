{ config, pkgs, ... }:

{
  imports = [
    ../modules/settings.nix
    ../modules/nixpkgs.nix
    ../modules/home-manager.nix
  ];

  services.nix-daemon.enable = true;
  services.emacs.enable = true;

  programs.zsh.enable = true;
  programs.tmux.enable = true;
}
