{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix

    ../../profiles/hardware.nix

    ./containers-archivekeep.nix
    ./containers-gitea.nix
    ./containers-grafana.nix
    ./containers-prometheus.nix
    ./containers-proxy.nix
    ./containers-seafile.nix
    ./containers-unbound.nix

    # unfinished
    # ./containers-ldap.nix

    ./firewall.nix

    ../../private/machines/cubie/containers.nix
    ../../private/machines/cubie/networking.nix
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";

  boot.loader.efi.canTouchEfiVariables = true;

  # Unlock LUKS device at boot
  boot.initrd.luks.devices = {
    "enc-system".device = "/dev/disk/by-uuid/ac2e408f-432e-4623-a4ff-4bea469d0a87";
    "enc-hdddata".device = "/dev/disk/by-id/md-uuid-1cc099f4:94a3981d:b89715c3:7a17952f";
    "enc-ssddata".device = "/dev/disk/by-id/md-uuid-b536ed2e:1762be89:58616e54:d1dac3ba";

    "enc-system" = {
      allowDiscards = true;
      keyFileSize = 4096;
      keyFile = "/dev/disk/by-id/usb-Verbatim_STORE_N_GO_9000170E9068E729-0:0-part2";
    };
    "enc-ssddata" = {
      allowDiscards = true;
      keyFileSize = 4096;
      keyFile = "/dev/disk/by-id/usb-Verbatim_STORE_N_GO_9000170E9068E729-0:0-part2";
    };
    "enc-hdddata" = {
      keyFileSize = 4096;
      keyFile = "/dev/disk/by-id/usb-Verbatim_STORE_N_GO_9000170E9068E729-0:0-part2";
    };
  };

  boot.kernelModules = [
    # Load modules for HW sensors
    "coretemp" "nct6775"

    # Add initrd modules for USB decryption key
    "usb_storage"
  ];

  # Do not use huge fonts for boot terminal
  hardware.video.hidpi.enable = false;


  powerManagement.powerUpCommands = with pkgs;''
    ${bash}/bin/bash -c '${hdparm}/bin/hdparm -B 254 -S 120 $(${utillinux}/bin/lsblk -dnp -o name,rota | ${gnugrep}/bin/grep ".*\\s1"| ${coreutils}/bin/cut -d" " -f1)'
  '';


  networking.hostName = "cubie";
  time.timeZone = "Europe/Bratislava";


  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  networking.nat = {
    enable = true;
    externalInterface = "enp1s0";

    # do not enable to not enable internet access
    # internalInterfaces = ["ve-+"];
    internalInterfaces = [ "ve-proxy+" ];
  };

  networking.dhcpcd = {
    # to make network-online.target wait for real network connection
    wait = "ipv4";
    extraConfig = "noipv4ll";
  };

  services.tailscale.enable = true;


  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };


  # prometheus system monitoring exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    port = 9100;
  };


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

