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
  version = "9ceb4a7bda09225d8aedf3a40f116b7f26791672";

  src = fetchFromGitHub {
    owner = "archivekeep";
    repo = "archivekeep";
    rev = "9ceb4a7bda09225d8aedf3a40f116b7f26791672";
    sha256 = "KIV4/VogtPkbPA7MLwJEp2OwS2xj/pjhDJUuvJB5BwU=";

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
  vendorSha256  = "1dMwRgCtjqbqVz/cUYyC5sAeO5sjXbotvLcW2lQbjCI=";

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
