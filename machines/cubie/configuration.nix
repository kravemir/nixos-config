{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix
    ../../profiles/gui.nix
    ../../profiles/gui-minimize.nix

    ../../profiles/hardware.nix
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";

  boot.loader.efi.canTouchEfiVariables = true;

  # Unlock LUKS device at boot
  boot.initrd.luks.devices = {
    "enc-system".device = "/dev/disk/by-uuid/ac2e408f-432e-4623-a4ff-4bea469d0a87";
    "enc-hdddata".device = "/dev/disk/by-uuid/7d0120f7-6f50-428e-9aa5-71a5fc44ff7c";
    "enc-ssddata".device = "/dev/disk/by-uuid/8ca24d0f-6140-49f0-b8d7-e8810f0b60b6";
  };

  # Load modules for HW sensors
  boot.kernelModules = [ "coretemp" "nct6775" ];

  # Do not use huge fonts for boot terminal
  hardware.video.hidpi.enable = false;


  networking.hostName = "cubie";
  time.timeZone = "Europe/Bratislava";


  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      22
    ];
  };

  services.tailscale.enable = true;


  services.openssh.enable = true;


  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  users.users.miroslav = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJXf2+nwLywvtY/2IvV/YZoz6h+k01XCML5THZCWvCknNlP3QF4GX8mbXwZjRZiTceXY5eiXXDEfsosJSG/qR+rj/b1o1a6dTNUmQkS9DmAISWwuqAgAhvAVjVfZTYOI7RbhkW3mtdGOzwUV/jTNXGXilFKh3U+hBfJF2UBi0iigThoeVPmpsmYyQwq3vpYXB2MVKKlA2are0WRH/7uPCRcA8gpKtm99QSowR5nj3dtSdP8difUSJ2AIdCH+q+n1hDrrdpL3+NtVmMUxR971J0YnJclf7GX21sdxU/RVi9J0ExakrKWTLCHGD49eTZ/hi9TiZA6k64LIUlJ1h6FpTEVluQLICU6zMCCz/lGMVel4l4uGa3HVuK6e1WknxEFuLxg2fCT5W33N4OIhl7313Kx795dbq8JPFgQP/8Ro5XzOlvNDZ3jVbqAEoR4+HWaRWYxQaMa4krru5fwQ7tAGLMz0MhpD/RmcpC/roC6/gyVnOHHHTwMUJF+jNPpx5txh3+2yf2pbi3EHZH5gzcaTpajqgTqsMaX8UB3oLXo5pRwMjgfbiB4BvDhA0XgdnMgi8dKnRhDAfseIZBSJvlBsk3PfzBzl/BfTp9QAKO3zF4APZ3zDVaDOhLQFZJRVDP6ZJKRPWqza6dhPqC+jjy4Hqh+b6N6VDV3k31qpNT5KgmGw=="
    ];
  };


  system.stateVersion = "21.11";
}

