{ config, pkgs, ... }:

{
  networking.bridges = {
    "br-grafprom".interfaces = [];
  };

  containers.grafana = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      services.grafana = {
        enable = true;
        port = 5049;
        addr = "";

        rootUrl = "http://cubie.home.kravemir.org/grafana/";

        provision = {
          enable = true;
          datasources = [
            {
              name = "Prometheus";

              isDefault = true;

              type = "prometheus";
              url = "http://192.168.150.3:5043";
            }
          ];
          dashboards = [
            {
              options.path = "/shared/grafana/dashboards";
            }
          ];
        };

        extraOptions = {
          USERS_DEFAULT_THEME = "light";
        };
      };

      networking.firewall.allowedTCPPorts = [
        5049
      ];
    };

    bindMounts = {
      "/shared/grafana/dashboards" = {
        hostPath = "/etc/nixos/grafana/dashboards";
      };
      "/var/lib/grafana" = {
        hostPath = "/storage/ssddata/grafana";
        isReadOnly = false;
      };
    };

    privateNetwork = true;

    extraVeths.grafProm2.hostBridge = "br-grafprom";
    extraVeths.grafProm2.localAddress = "192.168.150.2/24";
  };

  containers.prometheus = {
    extraVeths.grafProm3.hostBridge = "br-grafprom";
    extraVeths.grafProm3.localAddress = "192.168.150.3/24";
  };
}
