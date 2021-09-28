{ config, pkgs, ... }:

{
  imports = [ ../modules/settings.nix ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    tarball-ttl = 604800;
  };

  nix.package = pkgs.nix;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.${config.settings.username} = (import ../config);
  };

  services.nix-daemon.enable = true;
  services.emacs.enable = true;

  programs.zsh.enable = true;
  programs.tmux.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  time.timeZone = config.settings.timeZone;
  networking.hostName = config.settings.hostname;
}
