{ config, pkgs, lib,  ... }:

{
  virtualisation.docker.enable = true;

  services.ddccontrol.enable = true;
  services.tailscale.enable = true;

  # needed when routing all traffic through a VPN
  networking.firewall.checkReversePath = "loose";

  services.syncthing = {
    enable = true;

    user = "miroslav";
    group = "users";

    dataDir = "/home/miroslav";
  };

  users.users.miroslav = {
    isNormalUser = true;

    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    clipgrab

    home-manager

    ddccontrol
    ddccontrol-db

    wireguard-tools
  ];
}

