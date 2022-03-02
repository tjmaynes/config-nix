{ config, options, pkgs, ... }:

{
  imports = [ 
    <home-manager/nixos>
    ../../modules
  ];

  time.timeZone = config.settings.timeZone;

  networking.hostName = config.settings.hostname;
  networking.networkmanager.enable = true;
  
  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [ vim ];
  };

  programs.zsh.enable = true;

  home-manager.users.${config.settings.username} = (import ../../config);
}
