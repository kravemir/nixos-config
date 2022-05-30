{ lib,
  pkgs,
  stdenv,
  buildGo117Module,
  fetchFromGitHub,
  bash,
  installShellFiles
}:

let
  archivekeep-webui = pkgs.callPackage ./webui.nix {};
in
buildGo117Module rec {
  pname = "archivekeep";
  version = "3ecda63560fb58869e89f681cd4ac4cba53611cb";

  src = fetchFromGitHub {
    owner = "archivekeep";
    repo = "archivekeep";
    rev = "3ecda63560fb58869e89f681cd4ac4cba53611cb";
    sha256 = "1rysq342kjxq763my7m9fl5a9qm67s9d17wq4bdkxa4qnh6q7gh8";

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
  vendorSha256  = "01y7cgx4swrc41wyal2kack1iigsl2i4hv1mr3vc4nkrmns23p79";

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
