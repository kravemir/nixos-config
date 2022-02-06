{ config, pkgs, ... }:

{
  services.avahi.enable = false;

  services.gnome = {
    core-utilities.enable = false;

    tracker-miners.enable = false;
    tracker.enable = false;
  };

  programs.gnome-terminal.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gedit
    gnome.nautilus
  ];
}

