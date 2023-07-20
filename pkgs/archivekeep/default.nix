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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "archivekeep";
    repo = "archivekeep";
    rev = "v${version}";
    sha256 = "bAFChn8+uLCx1X73ofzn3wMDoRhRW5nRc+Bnirjf2Ns=";
  };


  proxyVendor   = true;
  vendorSha256  = "K6zFCYo+tM/rJ9QOFiE/dDCkr6BmAc/F7iGWWGfbb9w=";

  doCheck = false;

  preConfigure = ''
    cp -r "${archivekeep-webui}/dist/spa/" -T server/web/spa/embedded-assets
  '';

  tags = [ "embed_assets" ];

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
