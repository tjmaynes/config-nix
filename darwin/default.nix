{ config, options, pkgs, ... }:

{
  imports = [ 
    <home-manager/nix-darwin>
    ../modules/settings.nix
    ./preferences.nix
    ./startup.nix
  ];

  nixpkgs.config = import ../modules/nixpkgs.nix;

  nix.package = pkgs.nix;
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

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.${config.settings.username} = (import ../config);
  };

  networking.hostName = config.settings.hostname;
  time.timeZone = config.settings.timeZone;

  services.nix-daemon.enable = true;
  services.emacs.enable = true;

  programs.zsh.enable = true;
  programs.tmux.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = 4;
}
