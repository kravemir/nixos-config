{ config, pkgs, lib,  ... }:

let
  archivekeep = pkgs.callPackage ../pkgs/archivekeep {};
in
{
  services.ddccontrol.enable = true;
  services.tailscale.enable = true;

  services.ratbagd.enable = true;

  # needed when routing all traffic through a VPN
  networking.firewall.checkReversePath = "loose";

  services.syncthing = {
    enable = true;

    user = "miroslav";
    group = "users";

    dataDir = "/home/miroslav";

    openDefaultPorts = true;
  };

  users.users.miroslav = {
    isNormalUser = true;

    description = "Miroslav Kravec";

    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    archivekeep

    # archives
    p7zip

    ffmpeg
    yt-dlp

    home-manager

    # displays
    ddccontrol
    ddccontrol-db
    piper
    wayland-utils
    
    htop
    inxi
    exiftool
    bashmount
    skanpage
    simple-scan

    # VPN
    networkmanager-l2tp
    wireguard-tools

    thunderbird

    # virtualization
    virt-manager
    virtiofsd

    # networking
    iftop
    iperf
    wirelesstools

    # util
    (pkgs.callPackage ../pkgs/usb_reset.nix {})
  ];

  networking.firewall.allowedTCPPorts = [
    # for iperf
    5201
  ];
}

