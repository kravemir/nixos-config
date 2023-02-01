{ config, pkgs, lib,  ... }:

{
  # enable boot splash, see https://github.com/NixOS/nixpkgs/issues/26722
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" ];

  services.ddccontrol.enable = true;
  services.tailscale.enable = true;

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
    p7zip
    clipgrab

    home-manager

    # displays
    ddccontrol
    ddccontrol-db

    # VPN
    wireguard-tools

    # virtualization
    gnome.gnome-boxes
  ];
}

