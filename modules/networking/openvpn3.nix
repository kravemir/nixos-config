{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.openvpn3;
  
  openvpn3 = with pkgs; callPackage ../../pkgs/openvpn3.nix {
    inherit (python3Packages) docutils jinja2;
  };
in
{
  ###### interface

  options.services.openvpn3.client = {
    enable = mkEnableOption "Enable openvpn3 client.";
  };

  ###### implementation

  config = mkIf cfg.client.enable {
    services.dbus.packages = [
      openvpn3
    ];

    users.users.openvpn = {
      isSystemUser = true;
      group = "openvpn";
    };

    users.groups.openvpn = {};

    environment.systemPackages = [
      openvpn3
    ];
  };

}

