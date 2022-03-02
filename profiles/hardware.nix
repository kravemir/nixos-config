{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.memtest86.enable = true;

  services.fwupd.enable = true;

  services.smartd = {
    enable = true;

    autodetect = true;
    extraOptions = [
      "--interval=7200"
    ];

    notifications = {
      mail.enable = if config.services.postfix.enable then true else false;
      x11.enable = if config.services.xserver.enable then true else false;
      wall.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    nvme-cli
    usbutils
    pciutils

    lm_sensors
    smartmontools

    hdparm
  ];


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "memtest86-efi"
  ];
}

