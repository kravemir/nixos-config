{ config, pkgs, lib,  ... }:

let
  archivekeep = pkgs.callPackage ../pkgs/archivekeep {};
in
{
  # enable boot splash, see https://github.com/NixOS/nixpkgs/issues/26722
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" ];

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

    clipgrab

    home-manager

    # displays
    ddccontrol
    ddccontrol-db
    piper

    # VPN
    wireguard-tools

    thunderbird

    # virtualization
    gnome.gnome-boxes
  ];

  networking.firewall.allowedTCPPorts = [
    # for iperf
    5201
  ];
}

