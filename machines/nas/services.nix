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

  containers.gitea = {
    autoStart = true;

    config = { lib, config, pkgs, ... }: {
      services.sshd.enable = true;

      services.gitea = {
        enable = true;
        user = "git";

        rootUrl = "http://gitea:5080/";

        httpPort = 5080;
        ssh.clonePort = 5022;

        database.user = "git";
      };

      users.users.git = {
        uid = 2001;
        group = "gitea";
        description = "Gitea Service";
        isSystemUser = true;
        home = config.services.gitea.stateDir;
        useDefaultShell = true;
      };

      users.groups.gitea = lib.mkForce {
        gid = 2001;
      };

      networking.firewall.allowedTCPPorts = [
        22
        5080
      ];
    };

    bindMounts = {
      "/var/lib/gitea" = {
        hostPath = "/storage/data/gitea";
        isReadOnly = false;
      };
      # TODO: resolve localtime and timezone bind mounts
      # "/etc/timezone".hostPath = "/etc/timezone";
      # "/etc/localtime".hostPath = ":/etc/localtime";
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.61";

    forwardPorts = [
      {
        containerPort = 5080;
        hostPort = 5080;
        protocol = "tcp";
      }
      {
        containerPort = 22;
        hostPort = 5022;
        protocol = "tcp";
      }
    ];
  };

  containers.minidlna = {
    autoStart = true;

    config = { config, pkgs, ... }: {
      systemd.services.nscd.enable = false;

      services.minidlna.enable = true;
      services.minidlna.announceInterval = 1;
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

    # TODO - use privateNetwork instead of host's interfaces
    # privateNetwork = true;
    # hostAddress = "192.168.140.2";
    # localAddress = "192.168.140.62";

    forwardPorts = [
      {
        containerPort = 8200;
        hostPort = 8200;
        protocol = "tcp";
      }
      {
        containerPort = 1900;
        hostPort = 1900;
        protocol = "udp";
      }
    ];
  };
}

