{ config, pkgs, ... }:

let home = builtins.getEnv "HOME";

in {
  imports = [ ../settings.nix ];

  home = {
    packages = with pkgs; [
      adoptopenjdk-bin
      alacritty
      ffmpeg
      git
      home-manager
      htop
      jq
      mutt
      offlineimap
      pandoc
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
      enableNixDirenvIntegration = true;
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
      initExtra = ''
        if [[ -z "$(command -v brew)" ]]; then
          echo "Installing Homebrew..."
          ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
        fi

        if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
          echo "Installing Vim Plug..."
          curl -Lo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi

        if [[ ! -d "$HOME/.vim/plugged" ]]; then
          echo "Installing Vim plugins..."
          vim +'PlugInstall --sync' +qa
        fi
      '';
      shellAliases = {
        "ns" = "nix-shell --command zsh";
      };
      sessionVariables = {
        EDITOR = "vim";
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10";
      };
    };

    bash = {
      enable = true;
      historyFile = "${home}/.config/bash/.bash_history";
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
        "ll" = "ls -al";
        "ns" = "nix-shell --command zsh";
      };
      initExtra = ''
        if [[ -z "$(command -v brew)" ]]; then
          echo "Installing Homebrew..."
          ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
        fi

        if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
          echo "Installing Vim Plug..."
          curl -Lo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi

        if [[ ! -d "$HOME/.vim/plugged" ]]; then
          echo "Installing Vim plugins..."
          vim +'PlugInstall --sync' +qa
        fi
      '';
      sessionVariables = {
        EDITOR = "vim";
      };
    };

    texlive.enable = true;
  };
}
