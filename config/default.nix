{ config, pkgs, ... }:

let
  home = builtins.getEnv "HOME";
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
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
    WORKSPACE_DIR = "${home}/workspace";
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
        ]; 
        prompt.theme = "steeef";
      };
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
    };

    bash = {
      enable = true;
      historyFile = "${home}/.config/bash/.bash_history";
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
    };
  };
}
