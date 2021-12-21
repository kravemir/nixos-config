{ config, pkgs, ... }:

{
  services.fwupd.enable = true;

  services.smartd = {
    enable = true;
    autodetect = true;
    notifications = {
      mail.enable = if config.services.postfix.enable then true else false;
      x11.enable = if config.services.xserver.enable then true else false;
      wall.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    smartmontools
  ];
}

