{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     pkgs.arion
     pkgs.docker-client
  ];


  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.dnsname.enable = true;


  services.grafana = {
    enable = true;
    port = 5049;
    addr = "127.0.0.1";
  };

  services.prometheus = {
    enable = true;
    port = 5043;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "logind"
          "systemd"
        ];
        port = 9007;
      };
    };

    scrapeConfigs = [
      {
        job_name = "nas-host";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };

  containers.minidlna = {
    config = { config, pkgs, ... }: {
      systemd.services.nscd.enable = false;

      services.minidlna.enable = true;
      services.minidlna.announceInterval = 120;
      services.minidlna.friendlyName = "NAS";
      services.minidlna.mediaDirs = [
        "A,/storage/data/public/Audio/"
        "V,/storage/data/public/Videos/"
      ];
    };

    bindMounts = {
      "/storage/data/public" = {
        hostPath = "/storage/data/public";
        isReadOnly = false;
      };
    };

    # TODO - define container's network and forward ports
  };
}

