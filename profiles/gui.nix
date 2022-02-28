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

    # graphical tools
    digikam gimp inkscape

    # other tools
    filezilla
  ];
}

