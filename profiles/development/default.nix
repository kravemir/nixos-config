{ config, pkgs, lib, ... }:

{
  programs.direnv.enable = true;

  virtualisation.docker.enable = true;

  environment.variables = {
    JAVA_TOOLCHAIN_NIX_JDK8   = "${pkgs.jdk8}";
    JAVA_TOOLCHAIN_NIX_JDK11  = "${pkgs.jdk11}";
    JAVA_TOOLCHAIN_NIX_JDK17  = "${pkgs.jdk17}";

    OPEN_JDK_17 = "${pkgs.openjdk17}/lib/openjdk";
    OPEN_JDK_21 = "${pkgs.openjdk21}/lib/openjdk";
    TEMURIN_JDK_17 = "${pkgs.temurin-bin-17}";
    TEMURIN_JDK_21 = "${pkgs.temurin-bin-21}";
    GRAALVM_JDK = "${pkgs.graalvm-ce}";
  };


  environment.systemPackages = with pkgs; with jetbrains; [

    # JetBrains IDE(s)
    android-studio
    datagrip
    goland
    idea-ultimate
    pycharm-professional
    webstorm

    # JetBrains utils
    jcef

    gcc
    go
    jdk8

    docker-compose

    gh

    direnv
    nix-direnv
  ];

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  programs.adb.enable = true;

  users.users.miroslav.extraGroups = [
    "adbusers"
  ];
}

