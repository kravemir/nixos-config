{ config, pkgs, lib, ... }:

{
  environment.variables = {
    JAVA_TOOLCHAIN_NIX_JDK8   = "${pkgs.jdk8}";
    JAVA_TOOLCHAIN_NIX_JDK11  = "${pkgs.jdk11}";
    JAVA_TOOLCHAIN_NIX_JDK17  = "${pkgs.jdk17}";
  };

}

