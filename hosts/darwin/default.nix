{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
in {
  imports = [ 
    <home-manager/nix-darwin>
    ../../modules
    ./preferences.nix
  ];

  networking.hostName = config.settings.hostname;
  time.timeZone = config.settings.timeZone;

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

    users.${config.settings.username} = (import ../../modules/home-manager.nix);
  };

  services.nix-daemon.enable = true;
  services.emacs.enable = true;

  programs.zsh.enable = true;
  programs.tmux.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
