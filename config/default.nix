{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
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
    GIT_USERNAME = "${config.settings.username}";
    WORKSPACE_DIR = "${home}/workspace/${config.settings.username}";
    WORKSPACE_BACKUP_DIR = "${home}/workspace/${config.settings.username}-backups";
  };
in {
  imports = [ ../modules/settings.nix ];

  home = {
    file.".alacritty.yml".source = ./.alacritty.yml;
    file.".emacs".source = ./.emacs;
    file.".offlineimap.py".source = ./.offlineimap.py;
    file.".offlineimaprc".source = ./.offlineimaprc;
    file.".signature".source = ./.signature;
    file.".tmux.conf".source = ./.tmux.conf;
    file.".vimrc".source = ./.vimrc;
    file.".npmrc".source = ./.npmrc;
    file.".bash-fns.sh".source = ./fns.sh;
    file.".startup.sh".source = ./startup.sh;

    packages = with pkgs; [
      bat
      delta
      gnumake
      gnupg
      git
      home-manager
      htop
      jq
      lsd
      procs
      ripgrep
      tmux
      unzip
      vim
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
      userName = config.settings.name;
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
        . ${home}/.startup.sh
      '';
    };

    bash = {
      enable = false;
      historyFile = "${home}/.config/bash/.bash_history";
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
    };
  };
}
