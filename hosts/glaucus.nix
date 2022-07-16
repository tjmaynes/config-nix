{ config, pkgs, settings, ... }:

let 
  home = builtins.getEnv "HOME";
  mod = "Mod1";
in {
  settings = { hostname = "glaucus"; };

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    ./nixos
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 6443 ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.autorun = true;
  services.xserver.autoRepeatDelay = 250;
  services.xserver.dpi = 140;

  hardware.video.hidpi.enable = true;
  environment.variables.GDK_SCALE = "3.0";
  environment.variables.GDK_DPI_SCALE = "0.25";

  virtualisation.vmware.guest.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
  '';

  fonts.fonts = with pkgs; [
    corefonts
    inconsolata
    libertine
    libre-baskerville
  ];

  users.users.${config.settings.username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${config.settings.username}";
    description = "${config.settings.description}";
    extraGroups = [ "audio" "sound" "video" "docker" "networkmanager" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  services.k3s = {
    enable = true;
    role = "server";
  };

  home-manager.users.${config.settings.username} = {
    home = {
      stateVersion = "22.05";

      packages = with pkgs; [
        alacritty
        bitwarden
        brave
        cmus
        delta
        docker
        drawio
        feh
        ffmpeg
        go_1_18
        gimp
        k3s
        kubectl
        jetbrains.goland
        mpv
        mutt
        nodejs-16_x
        offlineimap
        packer
        pandoc
        pavucontrol
        python39
        texlive.combined.scheme-full
        vagrant
        vscode
        virtualbox
        xclip
        yarn2nix
        yarn
      ];
    };

    xsession.enable = true;

    xsession.windowManager.i3 = {
      enable = true;

      config = {
        modifier = mod;

        bars = [
          {
            id = "bar-0";
            position = "bottom";
            fonts = {
              names = [ config.settings.fontName ];
              size = config.settings.fontSize;
            };
          }
        ];

        keybindings = with pkgs.lib; mkOptionDefault ({
          "${mod}+Return" = "exec ${config.settings.terminal}";
        });
      };
    };

    programs.emacs.enable = true;
    services.emacs.enable = true;

    programs.zsh.initExtra = ''
      . ${home}/.startup.sh
    '';
  };
}
