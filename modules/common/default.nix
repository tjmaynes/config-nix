{ config, pkgs, ... }:

{
  imports = [ 
    ./settings.nix
    ./nixpkgs.nix
  ];

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [ vim ];
  };

  networking.hostName = config.settings.hostname;
  time.timeZone = config.settings.timeZone;

  services.nix-daemon.enable = true;
  services.emacs.enable = true;

  home-manager.users.${config.settings.username} = (import ./home-manager.nix);

  programs.zsh.enable = true;
  programs.tmux.enable = true;
}

