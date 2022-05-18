{ config, pkgs, ... }:

{
  containers.unbound = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      services.unbound = {
        enable = true;

        settings = {
          server = {
            logfile = "/var/lib/unbound/log";

            interface = [
              "0.0.0.0"
              "::0"
            ];

            log-servfail = true;

            access-control = [
              "10.0.0.0/8 allow"
              "127.0.0.0/8 allow"
              "192.168.0.0/16 allow"
            ];
          };

          forward-zone = [
            {
              name = ".";
              forward-tls-upstream = true;
              forward-addr = [
                "1.0.0.1@853#one.one.one.one"
                "1.1.1.1@853#one.one.one.one"
                "8.8.4.4@853#dns.google"
                "8.8.8.8@853#dns.google"
              ];
            }
          ];

          access-control-view = [
            "192.168.0.0/16 lanview"
            "100.64.0.0/10 tailscaleview"
          ];

          view = [
            {
              name = "lanview";
              local-zone = "home.kravemir.org inform";
              local-data = [
                "'cubie.home.kravemir.org 5 IN A 192.168.88.154'"
              ];
            }
            {
              name = "tailscaleview";
              local-zone = "home.kravemir.org inform";
              local-data = [
                "'cubie.home.kravemir.org 5 in A 100.121.230.54'"
              ];
            }
          ];
        };
      };

      users.users.undbound = {
        uid = 2004;
        group = "unbound";
        description = "Unbound Service";
        isSystemUser = true;
        home = config.services.unbound.stateDir;
        useDefaultShell = true;
      };

      users.groups.unbound = {
        gid = 2004;
      };

      networking.firewall.allowedTCPPorts = [ 53 ];
      networking.firewall.allowedUDPPorts = [ 53 ];
    };

    bindMounts = {
      "/var/lib/unbound" = {
        hostPath = "/storage/ssddata/unbound";
        isReadOnly = false;
      };
    };

    # TODO: enable private network for higher security
    # privateNetwork = true;
  };
}
