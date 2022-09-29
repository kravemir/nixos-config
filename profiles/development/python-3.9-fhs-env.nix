{
  pkgs ? import <nixpkgs> {},
  writeText ? pkgs.writeText,
  stdenv ? pkgs.stdenv,
}:

let
  pname = "python-3.9-fhs-env";

  fhs-etc = pkgs.callPackage ./fhs-etc.nix {};
in
(pkgs.buildFHSUserEnv {
  name = pname;

  targetPkgs = pkgs: (with pkgs; [
    starship
    bash-completion
    bashInteractive

    gnumake
    pkg-config

    python39
    python39Packages.pip
    python39Packages.poetry
    python39Packages.virtualenv

    musl

    libmysqlclient
    libmysqlclient.dev
    libtool
    libxml2
    libxml2.dev
    libxslt
    libxslt.dev
    xmlsec
    xmlsec.dev
    zlib
    zlib.dev

    fhs-etc
  ]);

  profile = ''
    declare -x IN_NIX_SHELL="impure"
    declare -x name="${pname}"
  '';
})

