{ config, pkgs, ... }:

{
  imports = [ ../modules/settings.nix ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    tarball-ttl = 604800;
  };
}
