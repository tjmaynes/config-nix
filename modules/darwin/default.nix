{ config, options, pkgs, ... }:

{
  imports = [
    ./homebrew.nix
    ./preferences.nix
  ];

  system.stateVersion = 4;

  nix.nixPath = [ "darwin=$HOME/.nix-defexpr/darwin" "nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs" ] ++ options.nix.nixPath.default;
  nix.extraOptions = ''
    system = x86_64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    build-users-group = nixbld
  '';

  time.timeZone = config.settings.timeZone;
  networking.hostName = config.settings.hostname;

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/Applications" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
