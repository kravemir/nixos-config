{ lib,
  pkgs,
  stdenv,
  buildGo119Module,
  fetchFromGitHub,
  bash,
  installShellFiles
}:

let
  archivekeep-webui = pkgs.callPackage ./webui.nix {};
in
buildGo119Module rec {
  pname = "archivekeep";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "archivekeep";
    repo = "archivekeep";
    rev = "v0.1.1";
    sha256 = "sf2EE8SEAUpce0bj133GEok/fKlU6Yft5DUk+SqLK6o=";
  };


  proxyVendor   = true;
  vendorSha256  = "sHh2jYRHI9rmYEwUO86R4f4xpJeIp5+qagaoKxLceJk=";

  doCheck = false;

  preConfigure = ''
    cp -r "${archivekeep-webui}/dist/spa/" -T server/web/spa/embedded-assets
  '';

  ldflags = [
    "-X github.com/archivekeep/archivekeep/internal/buildinfo.version=${version}"
  ];

  subPackages = [
    "."
    "./cmd/archivekeep-server"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd archivekeep-server \
      --bash <($out/bin/archivekeep-server completion bash) \
      --fish <($out/bin/archivekeep-server completion fish) \
      --zsh <($out/bin/archivekeep-server completion zsh)
  '';

  meta = with lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
