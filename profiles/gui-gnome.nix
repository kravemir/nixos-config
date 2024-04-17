{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager.gdm.enable = true;

  environment.systemPackages = with pkgs; [
    # gnome extensions
    gnome.gnome-power-manager
    gnome.gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.pop-shell
    gnomeExtensions.system-monitor
  ];
}

