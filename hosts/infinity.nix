{ config, ... }:

{ 
  imports = [ 
    <home-manager/nixos>
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
