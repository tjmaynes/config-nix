{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
in {
  imports = [ 
    <home-manager/nix-darwin>
    ../common
    ./preferences.nix
  ];

  environment = {
    pathsToLink = [ "/Applications" ];
  };

  nix.extraOptions = ''
    system = x86_64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    build-users-group = nixbld
  '';

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
