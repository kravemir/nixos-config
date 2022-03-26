{ config, pkgs, ... }:

{
  containers.seafile = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      imports = [
        ../../modules/seafile-custom.nix
      ];

      services.nginx = {
        enable = true;

        upstreams = {
          "seahub-gunicorn".servers = {
            "unix:/run/seahub/gunicorn.sock" = {};
          };
        };

        virtualHosts = {
          "seahub" = {
            listen = [
              { addr = "0.0.0.0"; port = 8085; }
            ];

            serverAliases = [
              "127.0.0.1"
              "cubie"
            ];

            locations."/".extraConfig = ''
              proxy_pass          http://seahub-gunicorn;
              proxy_set_header    Host $host;
              proxy_set_header    X-Real-IP $remote_addr;
              proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header    X-Forwarded-Host $server_name;
              proxy_read_timeout  1200s;

              # used for view/edit office file via Office Online Server
              client_max_body_size 0;
            '';

            locations."/seafhttp".extraConfig = ''
              rewrite               ^/seafhttp(.*)$ $1 break;
              proxy_pass            http://127.0.0.1:8082;
              client_max_body_size  0;
              proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;

              proxy_connect_timeout 36000s;
              proxy_read_timeout    36000s;
              proxy_send_timeout    36000s;

              send_timeout          36000s;
            '';
          };
        };
      };

      services.seafile-custom = {
        enable = true;

        ccnetSettings.General.SERVICE_URL = "http://cubie:8085";

        adminEmail = "kravec.miroslav@gmail.com";
        initialAdminPassword = "change-this-password";
      };


      users.users.seafile = {
        uid = 2002;
        group = "seafile";
        description = "Seafile Service";
        isSystemUser = true;
      };

      users.groups.seafile = lib.mkForce {
        gid = 2002;
      };

      networking.firewall.allowedTCPPorts = [
        8085
      ];
    };

    bindMounts = {
      "/var/lib/seafile/ssd" = {
        hostPath = "/storage/ssddata/files/seafile";
        isReadOnly = false;
      };
      "/var/lib/seafile" = {
        hostPath = "/storage/hdddata/files/seafile";
        isReadOnly = false;
      };
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.71";

    forwardPorts = [
      {
        containerPort = 8085;
        hostPort = 8085;
        protocol = "tcp";
      }
    ];
  };
}
