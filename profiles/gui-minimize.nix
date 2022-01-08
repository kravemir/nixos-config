{ config, pkgs, ... }:

{
  services.avahi.enable = false;

  services.gnome = {
    core-utilities.enable = false;

    tracker-miners.enable = false;
    tracker.enable = false;
  };

  programs.file-roller.enable = true;
  programs.gnome-terminal.enable = true;
}

