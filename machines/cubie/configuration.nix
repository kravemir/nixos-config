{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix
    ../../profiles/gui.nix
    ../../profiles/gui-minimize.nix

    ../../profiles/hardware.nix
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";

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


  users.users.miroslav = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };


  networking.firewall.enable = true;


  system.stateVersion = "21.11";
}

