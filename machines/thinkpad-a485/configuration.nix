{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/audio.nix
    ../../profiles/cli.nix
    ../../profiles/development
    ../../profiles/gui.nix
    ../../profiles/graphical-sway.nix
    ../../profiles/localization.nix
    ../../profiles/printing.nix
    ../../profiles/workstation.nix

    ../../profiles/hardware.nix
    ../../profiles/laptop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    google-chrome
    signal-desktop

    gcc
    gnumake
    go

    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.webstorm
  ];

  system.stateVersion = "22.11";
}
