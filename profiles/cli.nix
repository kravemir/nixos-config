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

    vim_customized

    git

    gptfdisk

    # backup tools
    borgbackup

    # resource monitoring tools
    nethogs iftop
  ];

  programs.bash = {
    promptInit = "eval \"$(starship init bash)\"";
  };

  programs.vim = {
    defaultEditor = true;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
}

