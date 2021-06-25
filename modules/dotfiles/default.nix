{ config, pkgs, ... }:

let 
  home = builtins.getEnv "HOME";
  initScript = ''
    if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    echo "Installing Vim Plug..."
    curl -Lo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    if [[ ! -d "$HOME/.vim/plugged" ]]; then
    echo "Installing Vim plugins..."
    vim +'PlugInstall --sync' +qa
    fi

    function pclone() {
    GIT_REPO=tjmaynes/$1

    if [[ -z "$GIT_REPO" ]]; then
      echo "Please provide a git repo as arg 1"  
    elif [[ ! -d "$WORKSPACE_DIR/$GIT_REPO" ]]; then
      git clone git@github.com:$GIT_REPO $WORKSPACE_DIR/$GIT_REPO
    fi

    [[ -d "$WORKSPACE_DIR/$GIT_REPO" ]] && cd $WORKSPACE_DIR/$GIT_REPO
   }
  '';
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
    "ll" = "ls -al";
    "ns" = "nix-shell --command zsh";
    "k" = "kubectl";
  };
  environmentVariables = {
    EDITOR = "vim";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=10";
    WORKSPACE_DIR = "${home}/workspace";
  };

in {
  imports = [ ../settings.nix ];

  home = {
    packages = with pkgs; [
      alacritty
      docker
      ffmpeg
      git
      home-manager
      htop
      jq
      mutt
      offlineimap
      pandoc
      texlive.combined.scheme-full
      tmux
      vim
      unzip
      zip
      zsh
    ]; 

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
    emacs.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tmux.enable = true;

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
      ignores = [".#*" "*.desktop" "*.lock"];
      extraConfig = {
        init.defaultBranch = "main";
        gpg.program = "gpg2";
        core.editor = "vim";
      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      dotDir = "${home}/.config/zsh";
      history = {
        expireDuplicatesFirst = true;
        path = "${home}/.config/zsh/.zsh_history";
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
      initExtra = initScript;
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
    };

    bash = {
      enable = true;
      historyFile = "${home}/.config/bash/.bash_history";
      initExtra = initScript;
      shellAliases = shellAliases; 
      sessionVariables = environmentVariables;
    };
  };
}
