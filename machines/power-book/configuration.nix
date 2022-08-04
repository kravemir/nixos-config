{ config, pkgs, lib,  ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix
    ../../profiles/development.nix
    ../../profiles/gui.nix
    ../../profiles/localization.nix
    ../../profiles/printing.nix
    ../../profiles/workstation.nix

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

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_18;

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

  # make dedicated GPU primary to prevent 1 FPS bug
  # https://gitlab.freedesktop.org/xorg/xserver/-/issues/1028
  services.xserver.config = ''
      Section "ServerLayout"
          Identifier "layout"
          Screen 0 "amdgpu"
          Inactive "apu"
      EndSection

      Section "Device"
          Identifier  "amdgpu"
          Driver      "modesetting"
          BusID       "PCI:3:0:0"
          Option      "DRI" "3"
          Option      "PrimaryGPU" "yes"
          Option      "TearFree" "true"
          Option      "VariableRefresh" "true"
      EndSection

      Section "Screen"
          Identifier "amdgpu"
          Device "amdgpu"
      EndSection

      Section "Device"
          Identifier  "apu"
          Driver      "modesetting"
          BusID       "PCI:7:0:0"
      EndSection

      Section "Screen"
          Identifier  "apu"
          Device      "apu"
          Option      "TearFree" "true"
          Option      "VariableRefresh" "true"
      EndSection
  '';

  services.xserver.displayManager = {
    # connect APU outputs (eDP, HDMI)
    setupCommands   = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
    sessionCommands = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
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
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.pycharm-professional
    jetbrains.webstorm

    awscli lens kubectl

    mongodb-compass
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
    "idea-ultimate"
    "goland"
    "pycharm-professional"
    "webstorm"

    "mongodb-compass"

    "Oracle_VM_VirtualBox_Extension_Pack"

    "steam"
    "steam-original"
  ];

  system.stateVersion = "21.11";
}

