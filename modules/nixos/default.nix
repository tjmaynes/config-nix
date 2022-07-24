{ config, options, pkgs, ... }:

{
  imports = [ 
    <home-manager/nixos>
    ../common
  ];

  networking.networkmanager.enable = true;

  home-manager.users.${config.settings.username} = (import ../common/home-manager.nix);
}
