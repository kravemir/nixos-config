# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.miroslav = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    git

    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.pycharm-professional
    jetbrains.webstorm
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
    "slack"

    "idea-ultimate"
    "goland"
    "pycharm-professional"
    "webstorm"
  ];

  services.udev.extraRules = ''
    # enable PCI Runtime Power Management (default is "on", always high-power)
    KERNEL=="0000:03:00.[01]",    SUBSYSTEM=="pci", ATTR{power/control}="auto"
    KERNEL=="0000:04:00.[0]",     SUBSYSTEM=="pci", ATTR{power/control}="auto"
    KERNEL=="0000:07:00.[01256]", SUBSYSTEM=="pci", ATTR{power/control}="auto"
  '';


  system.stateVersion = "21.11";
}

