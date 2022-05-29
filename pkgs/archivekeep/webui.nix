{ mkYarnPackage
, fetchFromGitHub
}:
mkYarnPackage rec {
  name = "archivekeep-webui";

  src = fetchFromGitHub {
    owner = "archivekeep";
    repo = "archivekeep-webui";
    rev = "1a27f23136a44ee4475d2d7de2cd7028e00da214";
    sha256 = "1b56hij2jv8fxhpylj4m2i01pxfrmyw2qwbziy2r9xgdvbp7rpwh";
  };

  packageJSON = ./webui-package.json;
  yarnLock = ./webui-yarn.lock;
  yarnNix = ./webui-yarn.nix;

  configurePhase = ''
    ln -s $node_modules node_modules
  '';

  buildPhase = ''
    yarn build --offline
  '';

  distPhase = "true";

  installPhase = ''
    mkdir -p $out/dist
    cp -r dist -T $out/dist
   '';
}
