# https://github.com/NixOS/nixpkgs/pull/247037
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.tang;
in
{
  options.services.tang = {
    enable = mkEnableOption "tang";

    package = mkOption {
      type = types.package;
      default = pkgs.tang;
      defaultText = literalExpression "pkgs.tang";
      description = mdDoc "The tang package to use.";
    };

    port = mkOption {
      type = types.port;
      default = 7654;
      description = mdDoc "The port to listen on.";
    };

  };
  config = mkIf cfg.enable {
    users = {
      users.tang = {
        group = "tang";
        isSystemUser = true;
      };
      groups.tang = { };
    };

    environment.systemPackages = [ pkgs.tang ];

    systemd.services."tangd@" = {
      description = "Tang server";
      path = [ pkgs.jose pkgs.tang ];
      preStart = ''
        if ! test -n "$(${pkgs.findutils}/bin/find /var/lib/tang -maxdepth 1 -name '*.jwk' -print -quit)"; then
          ${cfg.package}/libexec/tangd-keygen /var/lib/tang
        fi
      '';
      serviceConfig = {
        StandardInput = "socket";
        StandardOutput = "socket";
        StandardError = "journal";
        User = "tang";
        Group = "tang";
        StateDirectory = "tang";
        StateDirectoryMode = "700";
        ExecStart = "${cfg.package}/libexec/tangd /var/lib/tang";
      };
    };

    systemd.sockets = {
      tangd = {
        description = "Tang server";
        socketConfig = {
          ListenStream = cfg.port;
          Accept = "yes";
        };
      };
    };
  };
}
