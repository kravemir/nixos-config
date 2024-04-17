{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../profiles/cli.nix

    ../../profiles/gui.nix
    ../../profiles/gui-kde.nix

    ../../profiles/development

    ../../profiles/audio.nix
    ../../profiles/localization.nix
    ../../profiles/printing.nix
    ../../profiles/workstation.nix

    ../../profiles/hardware.nix
    ../../profiles/hardware-laptop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  boot.initrd.availableKernelModules = [
    # modules for AES disk encryption
    "aesni_intel"
    "cryptd"

    # for early KMS
    "amdgpu"
  ];


  networking.hostName = "miroslav-zbook";

  networking.networkmanager.enable = true;

  services.hardware.bolt.enable = true;

  # TODO: doesn't work well - asks on sudo with LID closed
  # services.fprintd.enable = true;

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  users.users.miroslav = {
    isNormalUser = true;
    description = "Miroslav Kravec";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "google-chrome"
    "slack"

    "android-studio-stable"
    "goland"
    "idea-ultimate"
    "pycharm-professional"
    "webstorm"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
