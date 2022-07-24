{ config, options, pkgs, ... }:

{
  imports = [ 
    <home-manager/nixos>
    ../common
  ];

  networking.networkmanager.enable = true;
}
