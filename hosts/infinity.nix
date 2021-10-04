{ config, ... }:

{ 
  imports = [ 
    <home-manager/nixos>
    ../../nixos/configuration.nix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.${config.settings.username} = (import ../../config);
  };

  services = {
    sshd.enable = true;
    cloud-init.enable = true;
  };
}
