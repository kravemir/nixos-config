{ config, pkgs, lib,  ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/networking/openvpn3.nix

    ../../profiles/cli.nix
    ../../profiles/gui.nix
    ../../profiles/localization.nix

    ../../profiles/hardware.nix
    ../../profiles/laptop.nix

    ./private.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    "enc-laptop".device = "/dev/disk/by-uuid/5dbb9f4d-7622-4383-8084-ad45ded32d1d";
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_17;

  networking.hostName = "miroslav-power-book";

  services.xserver.displayManager.gdm.wayland = false;

  nix.extraOptions = "keep-outputs = true";

  services.openvpn3.client.enable = true;

  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  powerManagement.powerUpCommands = with pkgs;''
    ${bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'
  '';

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users.users.miroslav = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    jdk8

    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.pycharm-professional
    jetbrains.webstorm

    mongodb-compass
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "google-chrome"
    "memtest86-efi"

    "zoom"
    "slack"

    "idea-ultimate"
    "goland"
    "pycharm-professional"
    "webstorm"

    "mongodb-compass"
  ];

  services.udev.extraRules = ''
    # enable PCI Runtime Power Management (default is "on", always high-power)
    KERNEL=="0000:03:00.[01]",    SUBSYSTEM=="pci", ATTR{power/control}="auto"
    KERNEL=="0000:04:00.[0]",     SUBSYSTEM=="pci", ATTR{power/control}="auto"
    KERNEL=="0000:07:00.[01256]", SUBSYSTEM=="pci", ATTR{power/control}="auto"
  '';


  system.stateVersion = "21.11";
}

