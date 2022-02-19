{ config, pkgs, ... }:

{
  containers.prometheus = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      services.prometheus = {
        enable = true;
        port = 5043;

        globalConfig = {
          scrape_interval = "30s";
        };

        scrapeConfigs = [
          {
            job_name = "cubie";
            static_configs = [{
              targets = [ "cubie:9100" ];
            }];
          }
        ];
      };

      networking.hosts = {
        "192.168.140.2" = [ "cubie" ];
      };

      networking.firewall.allowedTCPPorts = [
        5043
      ];
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.64";

    bindMounts = {
      "/var/lib/prometheus2" = {
        hostPath = "/storage/ssddata/monitoring/prometheus2";
        isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = 5043;
        hostPort = 5043;
        protocol = "tcp";
      }
    ];
  };
}
