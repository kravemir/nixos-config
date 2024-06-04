{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.defaultSession = "plasma";

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.wayland.compositor = "kwin";

  services.xserver.desktopManager.xterm.enable = false;

  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.notoPackage = pkgs.noto-fonts-lgc-plus;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

