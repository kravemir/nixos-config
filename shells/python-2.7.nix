{ pkgs ? import <nixpkgs> {}}:

let
  pythonPackages = pkgs.python27Packages;

  lib-path = with pkgs; lib.makeLibraryPath [
    stdenv.cc.cc.lib
    file
  ];

  virtualEnv_16_7= pythonPackages.buildPythonApplication rec {
    pname = "virtualenv";
    version = "16.7.12";

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-HKCaihaEuhWRXuuzC7c5iPevR64x9IVEzIctLVYMFzg=";
    };

    doCheck = false;

    pyproject = true;
    build-system = with pythonPackages; [
      setuptools
      wheel
    ];
  };

in pkgs.mkShell rec {
  name = "Python 2.7";

  buildInputs = with pkgs; [
    postgresql
    redis

    deno

    python27Full
    virtualEnv_16_7

    taglib
    openssl
    git
    libtool
    libxml2
    libxslt
    libzip
    xmlsec
    zlib
  ];

  shellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH

    export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
  '';
}
