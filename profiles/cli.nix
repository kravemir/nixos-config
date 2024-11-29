{ config, pkgs, ... }:

let
  vim_customized = (pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
      start = [
        vim-airline
        vim-nix
        vim-lastplace

        editorconfig-vim
      ];
      opt = [];
    };
    vimrcConfig.customRC = ''
      set nocompatible

      " enable secure project specific .vimrc
      set exrc
      set secure

      " indentation
      set smartindent
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set smarttab
      filetype indent on
      filetype on

      " syntax highlighting
      syntax on
      syntax enable

      " rendering
      set number
      set lazyredraw
      set showmatch

      " editing
      set backspace=indent,eol,start
    '';
  });
in
{
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    starship

    # editing tools
    yq-go vim_customized

    # developer tools
    git sqlite

    # disk and partition manipulation tools
    gptfdisk parted

    # backup tools
    borgbackup

    # networking
    bind

    # resource monitoring tools
    gotop
    iftop
    nethogs

    # virtual env
    direnv

    # other
    lftp
    unzip
    freshfetch
    exiftool
    (callPackage ../pkgs/cut_video.nix {})
  ];

  programs.bash = {
    promptInit = ''
      # use https://starship.rs/ prompt
      eval "$(starship init bash)"

      # Eternal bash history.
      # ---------------------
      # Undocumented feature which sets the size to "unlimited".
      # https://stackoverflow.com/questions/9457233/unlimited-bash-history
      export HISTFILESIZE=
      export HISTSIZE=
      # Change the file location because certain bash sessions truncate .bash_history file upon close.
      # http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
      export HISTFILE=~/.bash_eternal_history
      # Force prompt to write history after every command.
      # http://superuser.com/questions/20900/bash-history-loss
      PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
    '';
  };

  programs.vim = {
    package = vim_customized;
    defaultEditor = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
}

