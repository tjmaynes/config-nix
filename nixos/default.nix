{ config, pkgs, settings, ... }:

{ 
  imports = [ 
    <home-manager/nixos>
    ../modules/settings.nix
  ];

  time.timeZone = config.settings.timeZone;

  nixpkgs.config = import ../modules/nixpkgs.nix; 
  nix.package = pkgs.nix;

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [ vim ];
  };

  programs.zsh.enable = true;

  home-manager.users.${config.settings.username} = (import ../config);

  system.stateVersion = "21.11";
}
