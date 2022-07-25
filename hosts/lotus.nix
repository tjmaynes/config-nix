{ config, lib, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "lotus"; };

  imports = [ ../modules/common ];

  home-manager.users.${config.settings.username} = {
    home = {
      stateVersion = "22.05";

      packages = with pkgs; [
        emulationstation
        jellyfin-media-player
      ];
    };
  };
}
