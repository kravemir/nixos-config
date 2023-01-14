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
  version = "4d76f7adc58143d3d05e4116e8955ee070107fc3";

  src = fetchFromGitHub {
    owner = "archivekeep";
    repo = "archivekeep";
    rev = "4d76f7adc58143d3d05e4116e8955ee070107fc3";
    sha256 = "S29zJ4YJ7mmcUJJN/CXZrT5xmqveng6OgyEXKfYOlro=";

    leaveDotGit = true;
    postFetch = ''
      cd "$out"

      git add .
      git checkout HEAD -- .

      ${bash}/bin/bash ./bin/generate-version.sh

      rm -rf .git
    '';
  };


  proxyVendor   = true;
  vendorSha256  = "FooWfkkaTIOJ4Sge8VDov7x4uPsU+VRdYaoDx0V7U6E=";

  doCheck = false;

  preConfigure = ''
    cp -r "${archivekeep-webui}/dist/spa/" -T server/web/spa/embedded-assets
  '';

  tags = [ "embed_assets" "embed_version" ];

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
