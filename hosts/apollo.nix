{ config, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
in {
  settings = { hostname = "apollo"; };

  imports = [ 
    ../modules/common/nixpkgs.nix
    ../modules/home-manager 
  ];

  home = {
    username = "${config.settings.username}";
    homeDirectory = "${home}";

    packages = with pkgs; [
      alacritty
      brave
      jetbrains.goland
      mpv
      vscode
      texlive.combined.scheme-full
    ];
  };

  programs.zsh = {
    sessionVariables = { 
      XDG_DATA_DIRS = "${home}/.nix-profile/share:$XDG_DATA_DIRS";
    };
  };

  programs.bash = {
    sessionVariables = { 
      XDG_DATA_DIRS = "${home}/.nix-profile/share:$XDG_DATA_DIRS";
    };
  };
}
