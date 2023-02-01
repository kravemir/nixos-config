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

        settings.server = {
          http_port = 5049;
          http_addr = "";

          root_url = "http://cubie.home.kravemir.org/grafana/";
        };

        provision = {
          enable = true;

          datasources.settings.datasources = [
            {
              name = "Prometheus";

              isDefault = true;

              type = "prometheus";
              url = "http://192.168.150.3:5043";
            }
          ];

          dashboards.settings.providers = [
            {
              options.path = "/shared/grafana/dashboards";
            }
          ];
        };

        settings.users = {
          default_theme = "light";
        };
      };

      networking.firewall.allowedTCPPorts = [
        5049
      ];

      system.stateVersion = "22.05";
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
