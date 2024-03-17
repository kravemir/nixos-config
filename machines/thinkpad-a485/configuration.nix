{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/audio.nix
    ../../profiles/cli.nix
    ../../profiles/development
    ../../profiles/gui.nix
    ../../profiles/localization.nix
    ../../profiles/printing.nix
    ../../profiles/workstation.nix

    ../../profiles/hardware.nix
    ../../profiles/laptop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    "enc-system".device = "/dev/disk/by-uuid/27de2117-d606-4d91-87e2-462369ca244a";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", SYMLINK+="ttyZBDongleE", OWNER="9001", GROUP="9001", TAG+="systemd"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="zwave", OWNER="9001", GROUP="9001", TAG+="systemd"
  '';

  boot.initrd.availableKernelModules = [
    # modules for AES disk encryption
    "aesni_intel"
    "cryptd"

    # for early KMS
    "amdgpu"
  ];

  networking.hostName = "miroslav-thinkpad";

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "google-chrome"
    "obsidian"
    "slack"

    "android-studio-stable"
    "goland"
    "idea-ultimate"
    "pycharm-professional"
    "webstorm"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  environment.systemPackages = with pkgs; [
    google-chrome
    obsidian
    signal-desktop

    gcc
    gnumake
    go

    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.webstorm
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
