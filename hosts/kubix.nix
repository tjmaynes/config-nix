{ ... }:

{ 
  imports = [ 
    ../../nixos/configuration.nix
  ];

  services = {
    sshd.enable = true;
    cloud-init.enable = true;
  };
}
