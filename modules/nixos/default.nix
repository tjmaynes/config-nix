{ config, options, pkgs, ... }:

{
  imports = [ 
    <home-manager/nixos>
    ../common
  ];

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [ vim ];
  };

  networking.networkmanager.enable = true;

  home-manager.users.${config.settings.username} = (import ../home-manager);
}
