{ config, pkgs, lib, ... }:


let
  python-3_9-fhs-env = pkgs.callPackage ./python-3.9-fhs-env.nix {};
  pycharm-professional-in-fhs-env = pkgs.callPackage ./pycharm-professional-in-fhs-env.nix {};
in
{
  virtualisation.docker.enable = true;

  environment.variables = {
    JAVA_TOOLCHAIN_NIX_JDK8   = "${pkgs.jdk8}";
    JAVA_TOOLCHAIN_NIX_JDK11  = "${pkgs.jdk11}";
    JAVA_TOOLCHAIN_NIX_JDK17  = "${pkgs.jdk17}";
  };


  environment.systemPackages = with pkgs; [
    python-3_9-fhs-env
    pycharm-professional-in-fhs-env

    gcc
    go_1_19
    jdk8

    android-studio

    docker-compose

    gh

    direnv
    nix-direnv
  ];

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  programs.adb.enable = true;

  virtualisation.virtualbox.host = {
    enable = true;

    enableExtensionPack = true;
  };

  users.users.miroslav.extraGroups = [
    "adbusers"
    "vboxusers"
  ];
}

