# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix
    ../../profiles/localization.nix

    ../../profiles/hardware.nix
  ];

  # Use GRUB boot loader for legacy BIOS Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.device = "/dev/disk/by-id/usb-Realtek_RTL9210_NVME_012345681310-0:0";

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."enc-system".device = "/dev/disk/by-uuid/a2d1776e-07e3-4c15-b7fb-c1ef1d6ad91b";

  networking.hostName = "nixos-live-usb";

  networking.useDHCP = false;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  users.users.miroslav = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  networking.firewall.enable = true;

  system.stateVersion = "21.11"; # Did you read the comment?
}

