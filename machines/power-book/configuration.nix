{ config, pkgs, lib,  ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix
    ../../profiles/development
    ../../profiles/gui.nix
    ../../profiles/localization.nix
    ../../profiles/printing.nix
    ../../profiles/workstation.nix

    ../../profiles/hardware.nix
    ../../profiles/laptop.nix

    ./gpu.nix
    ./private.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    "enc-laptop".device = "/dev/disk/by-uuid/5dbb9f4d-7622-4383-8084-ad45ded32d1d";
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_0;

  networking.hostName = "miroslav-power-book";

  services.xserver.displayManager.gdm.wayland = false;

  nix.extraOptions = "keep-outputs = true";

  # disable for TLP, auto-enabled by gnome-core by default
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;

    settings = {
      START_CHARGE_THRESH_BAT0  = 72;
      STOP_CHARGE_THRESH_BAT0   = 80;

      CPU_SCALING_GOVERNOR_ON_AC  = "ondemand";
      CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
      CPU_BOOST_ON_AC             = 0;
      CPU_BOOST_ON_BAT            = 0;
      PLATFORM_PROFILE_ON_AC      = "balanced";
      PLATFORM_PROFILE_ON_BAT     = "quiet";

      USB_DENYLIST = "0bda:8153";
      USB_EXCLUDE_AUDIO = false;

      RUNTIME_PM_ON_AC    = "auto";
      RUNTIME_PM_ON_BAT   = "auto";
      RUNTIME_PM_DISABLE  = "07:00.3 07:00.4";
    };
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  environment.systemPackages = with pkgs; [
    jetbrains.datagrip
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.webstorm

    awscli lens kubectl

    mongodb-compass

    ffmpeg
    mediainfo
    (pkgs.callPackage ../../pkgs/cut_video.nix {})
  ];

  programs.steam.enable = true;

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

    "android-studio-stable"
    "datagrip"
    "idea-ultimate"
    "goland"
    "pycharm-professional"
    "webstorm"

    "mongodb-compass"

    "Oracle_VM_VirtualBox_Extension_Pack"

    "steam"
    "steam-original"
    "steam-run"
  ];

  system.stateVersion = "21.11";
}

