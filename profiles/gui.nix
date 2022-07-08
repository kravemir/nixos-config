{ config, pkgs, ... }:

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
    signal-desktop
    slack
    zoom-us

    # editors
    apostrophe

    # graphical tools
    digikam gimp inkscape

    # office
    hunspell
    hunspellDicts.cs-cz
    hunspellDicts.en-us
    hunspellDicts.en-gb-large
    hunspellDicts.sk-sk
    libreoffice

    # other tools
    filezilla

    # gnome extensions
    gnome.gnome-power-manager
    gnome.gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.system-monitor
    gnomeExtensions.x11-gestures
  ];
}

