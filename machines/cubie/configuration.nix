{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.systemd-boot.memtest86.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  # Unlock LUKS device at boot
  boot.initrd.luks.devices = {
    "enc-system".device = "/dev/disk/by-uuid/ac2e408f-432e-4623-a4ff-4bea469d0a87";
  };

  # Do not use huge fonts for boot terminal
  hardware.video.hidpi.enable = false;


  networking.hostName = "cubie";
  time.timeZone = "Europe/Bratislava";


  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;


  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
 

  services.smartd = {
    enable = true;
    notifications = {
      x11.enable = if config.services.xserver.enable then true else false;
      wall.enable = true;
    };
  };


  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;


  users.users.miroslav = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };


  environment.systemPackages = with pkgs; [
    git

    vim
    wget
    firefox

    nvme-cli
    usbutils
    pciutils

    lm_sensors
    smartmontools
  ];


  networking.firewall.enable = true;


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "memtest86-efi"
  ];


  system.stateVersion = "21.11";
}

