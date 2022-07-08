{ config, pkgs, lib,  ... }:

{
  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

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
  ];
}

