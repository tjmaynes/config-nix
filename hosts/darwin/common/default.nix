{ config, options, pkgs, ... }:

{
  imports = [ 
    ./preferences.nix
    ./homebrew.nix
  ];

  system.stateVersion = 4;

  nix.nixPath = [ "darwin=$HOME/.nix-defexpr/darwin" "nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs" ] ++ options.nix.nixPath.default;
  nix.extraOptions = ''
    system = x86_64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    build-users-group = nixbld
  '';

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/Applications" ];
  };
}
