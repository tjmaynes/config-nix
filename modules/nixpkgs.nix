{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    tarball-ttl = 604800;
  };
  nix.package = pkgs.nix;
}
