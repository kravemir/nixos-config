{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, git
, pkg-config
, glib
, jsoncpp
, libcap_ng
, libnl
, libuuid
, lz4
, openssl
, protobuf
, python3
, tinyxml-2

, docutils
, jinja2
}:

stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "17_beta";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "v${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    sha256 = "1x8v43l9ryvky6agr8sa2s8i3az6r1fwzbf17hg32vvg5q0yp1n7";
  };

  postPatch = ''
    ./update-version-m4.sh
    patchShebangs ./openvpn3-core/scripts/version
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    docutils
    git
    jinja2
    pkg-config
  ];
  propagatedBuildInputs = [
    python3
  ];
  buildInputs = [
    glib
    jsoncpp
    libcap_ng
    libnl
    libuuid
    lz4
    openssl
    protobuf
    tinyxml-2
  ];

  configureFlags = [ "--disable-selinux-build" ];

  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "OpenVPN 3 Linux client";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
