{ config, pkgs, lib, ... }:

{
  environment.variables = {
    JAVA_TOOLCHAIN_NIX_JDK8   = "${pkgs.jdk8}";
    JAVA_TOOLCHAIN_NIX_JDK11  = "${pkgs.jdk11}";
    JAVA_TOOLCHAIN_NIX_JDK17  = "${pkgs.jdk17}";
  };


  environment.systemPackages = with pkgs; [
    gcc
    go_1_18
    jdk8

    android-studio

    direnv
    nix-direnv
  ];

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  programs.adb.enable = true;

  users.users.miroslav.extraGroups = [ "adbusers" ];
}

