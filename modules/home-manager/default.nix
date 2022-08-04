{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
  projectRoot = "${home}/workspace/${config.settings.gitUsername}/config";
  dotfilesDir = "${projectRoot}/dotfiles";
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../"; "......" = "cd ../../../../../";
    "ll" = "ls -al";
    "ns" = "nix-shell --command zsh";
    "k" = "kubectl";
    "ls" = "lsd";
    "cat" = "bat";
    "ps" = "procs";
  };
  environmentVariables = {
    EDITOR = "vim";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=10";
    HOST_GIT_USERNAME = "${config.settings.gitUsername}";
    HOST_USERNAME = "${config.settings.username}";
    HOST_EMAIL = "${config.settings.email}";
    WORKSPACE_DIR = "${home}/workspace/${config.settings.gitUsername}";
    BACKUP_DIR = "${home}/backups";
  };
in {
  imports = [ ../common/settings.nix ];

  home = {
    stateVersion = "22.05";

    file.".alacritty.yml".source = "${dotfilesDir}/system/.alacritty.yml";
    file.".emacs".source = "${dotfilesDir}/system/.emacs";
    file.".offlineimap.py".source = "${dotfilesDir}/system/.offlineimap.py";
    file.".offlineimaprc".source = "${dotfilesDir}/system/.offlineimaprc";
    file.".signature".source = "${dotfilesDir}/system/.signature";
    file.".tmux.conf".source = "${dotfilesDir}/system/.tmux.conf";
    file.".vimrc".source = "${dotfilesDir}/system/.vimrc";
    file.".npmrc".source = "${dotfilesDir}/system/.npmrc";
    file.".bash_onstart.sh".source = "${dotfilesDir}/system/.bash_onstart.sh";

    packages = with pkgs; [
      bat
      delta
      docker
      ffmpeg
      git
      gnumake
      gnupg
      go_1_18
      home-manager
      htop
      jq
      lsd
      pandoc
      procs
      ripgrep
      tmux
      unzip
      vim
      yarn2nix
      yarn
      zip
      zsh
    ];
  };

  programs = {
    home-manager.enable = true;
    tmux.enable = true;
    emacs.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = config.settings.gitUsername;
      userEmail = config.settings.email;
      aliases = {
        co = "checkout";
        st = "status";
        conflicts = "ls-files --unmerged | cut -f2 | sort -u";
        llog = "log --date=local";
        flog = "log --pretty=fuller --decorate";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        lol = "log --graph --decorate --oneline";
        lola = "log --graph --decorate --oneline --all";
        ditch = "reset --hard";
        ditchall = "reset --hard && git clean -fd";
        d = "difftool";
        diffc = "diff --cached";
        smp = "submodule foreach git pull origin master";
        sgc = "og --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(cyan)(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative";
        patience = "merge --strategy-option=patience";
        aliases = "config --get-regexp alias";
        pushf = "push --force-with-lease";
        s = "status -s -uno";
        gl = "log --oneline --graph";
      };
      ignores = [".#*" "*.desktop"];
      extraConfig = {
        core.editor = "vim";
        diff.tool = "delta";
        gpg.program = "gpg2";
        init.defaultBranch = "main";
      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      history = {
        expireDuplicatesFirst = true;
      };
      prezto = {
        enable = true;
        pmodules = [
          "environment"
          "terminal"
          "editor"
          "history"
          "directory"
          "spectrum"
          "utility"
          "completion"
          "prompt"
          "ssh"
          "git"
          "python"
          "tmux"
          "gpg"
          "helper"
          "docker"
        ]; 
        prompt.theme = "steeef";
      };
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
      initExtra = ''
        if [[ -e "${home}/.nix-profile/etc/profile.d/nix.sh" ]]; then
          . ${home}/.nix-profile/etc/profile.d/nix.sh
        fi

        . ${home}/.bash_onstart.sh
      '';
    };

    bash = {
      enable = true;
      historyFile = "${home}/.config/bash/.bash_history";
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
      initExtra = ''
        . ${home}/.bash_onstart.sh
      '';
    };
  };
}
