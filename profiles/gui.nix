{ config, pkgs, ... }:

let
  inkscape-old-pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz";
  }) {};
in
{
  services.xserver.enable = true;

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    # browsers
    firefox google-chrome

    # communication tools
    element-desktop
    signal-desktop
    slack

    # editors
    apostrophe

    # fonts
    gyre-fonts
    libertine

    # graphical tools
    darktable
    drawio
    digikam
    gimp
    inkscape-old-pkgs.inkscape

    # multimedia
    vlc

    # office
    hunspell
    hunspellDicts.cs-cz
    hunspellDicts.en-us
    hunspellDicts.en-gb-large
    hunspellDicts.sk-sk
    libreoffice

    # office & graphics fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts

    # other tools
    filezilla
    foliate

    # gnome extensions
    gnome.gnome-power-manager
    gnome.gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.pop-shell
    gnomeExtensions.system-monitor
  ];
}

