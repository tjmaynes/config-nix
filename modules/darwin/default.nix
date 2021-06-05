{ pkgs, ... }:

{
  system.stateVersion = 4;

  imports = [
    ../nixpkgs.nix
    ./home-manager.nix
    ./preferences.nix
    ./brew.nix
  ];

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/Applications" ];
  };

  programs.zsh.enable = true;
  programs.tmux.enable = true;

  services.nix-daemon.enable = true;
  services.emacs.enable = true;
}
