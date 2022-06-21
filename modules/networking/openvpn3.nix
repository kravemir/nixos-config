{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.openvpn3;

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  ###### interface

  options.services.openvpn3.client = {
    enable = mkEnableOption "Enable openvpn3 client.";
  };

  ###### implementation

  config = mkIf cfg.client.enable {
    services.dbus.packages = [
      unstable.openvpn3
    ];

    users.users.openvpn = {
      isSystemUser = true;
      group = "openvpn";
    };

    users.groups.openvpn = {};

    environment.systemPackages = [
      unstable.openvpn3
    ];
  };

}

