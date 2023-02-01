{ config, pkgs, ... }:

{
  networking.bridges = {
    "br-proxy-archi".interfaces = [];
    "br-proxy-gitea".interfaces = [];
    "br-proxy-grafa".interfaces = [];
    "br-proxy-seafi".interfaces = [];
  };

  containers.proxy = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      services.nginx = {
        enable = true;

        appendHttpConfig = ''
          # this is required to proxy Grafana Live WebSocket connections.
          map $http_upgrade $connection_upgrade {
            default upgrade;
            ''' close;
          }
        '';

        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;

        virtualHosts."cubie.home.kravemir.org" = {
          forceSSL = true;

          sslCertificateKey = "/var/lib/acme/cubie.home.kravemir.org/key.pem";
          sslCertificate    = "/var/lib/acme/cubie.home.kravemir.org/fullchain.pem";

          locations."/archivekeep/" = {
            proxyPass = "http://192.168.164.3:4202/";
          };

          locations."/gitea/" = {
            proxyPass = "http://192.168.161.3:5080/";

            extraConfig = ''
              # proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          locations."/grafana/" = {
            proxyPass = "http://192.168.162.3:5049/";

            extraConfig = ''
              # proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
          locations."/grafana/api/live" = {
            proxyPass = "http://192.168.162.3:5049/";

            extraConfig = ''
              rewrite  ^/grafana/(.*)  /$1 break;

              proxy_http_version 1.1;
              # proxy_set_header Host $host;
              proxy_set_header Connection $connection_upgrade;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          locations."/seafile/" = {
            proxyPass = "http://192.168.163.3:8085/seafile/";

            extraConfig = ''
              # rewrite  ^/seafile/(.*)  /$1 break;
            '';
          };

          locations."/seafhttp/" = {
            proxyPass = "http://192.168.163.3:8085/seafhttp/";

            extraConfig = ''
              # rewrite  ^/seafile/(.*)  /$1 break;
            '';
          };
        };
      };

      security.acme = {
        acceptTerms = true;

        defaults.email = "kravec.miroslav@gmail.com";

        certs."cubie.home.kravemir.org" = {
          domain = "cubie.home.kravemir.org";
          dnsProvider = "acme-dns";

          credentialsFile = pkgs.writeText "cert-env.txt" ''
            ACME_DNS_API_BASE=https://auth.acme-dns.io
            ACME_DNS_STORAGE_PATH=/var/lib/acme/config/credentials.json
          '';
        };
      };

      users.users.acme = {
        uid = 2005;
        group = "acme";
        description = "ACME Service";
        isSystemUser = true;
      };

      users.users.nginx = lib.mkForce {
        uid = 2006;
        group = "nginx";
        description = "NGINX Service";
        isSystemUser = true;
        extraGroups = [ "acme" ];
      };

      users.groups.acme = {
        gid = 2005;
      };

      users.groups.nginx = lib.mkForce {
        gid = 2006;
      };

      environment.systemPackages = with pkgs; [
        lego
      ];

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      system.stateVersion = "22.05";
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.75";

    bindMounts = {
      "/var/lib/acme" = {
        hostPath = "/storage/ssddata/proxy/acme";
        isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 80;
        protocol = "tcp";
      }
      {
        containerPort = 443;
        hostPort = 443;
        protocol = "tcp";
      }
    ];
  };

  containers.proxy = {
    extraVeths.proxyToArchi.hostBridge = "br-proxy-archi";
    extraVeths.proxyToArchi.localAddress = "192.168.164.2/24";

    extraVeths.proxyToGitea.hostBridge = "br-proxy-gitea";
    extraVeths.proxyToGitea.localAddress = "192.168.161.2/24";

    extraVeths.proxyToGrafa.hostBridge = "br-proxy-grafa";
    extraVeths.proxyToGrafa.localAddress = "192.168.162.2/24";

    extraVeths.proxyToSeafi.hostBridge = "br-proxy-seafi";
    extraVeths.proxyToSeafi.localAddress = "192.168.163.2/24";
  };

  containers.archivekeep = {
    extraVeths.archiToProxy.hostBridge = "br-proxy-archi";
    extraVeths.archiToProxy.localAddress = "192.168.164.3/24";
  };

  containers.gitea = {
    extraVeths.giteaToProxy.hostBridge = "br-proxy-gitea";
    extraVeths.giteaToProxy.localAddress = "192.168.161.3/24";
  };

  containers.grafana = {
    extraVeths.grafaToProxy.hostBridge = "br-proxy-grafa";
    extraVeths.grafaToProxy.localAddress = "192.168.162.3/24";
  };

  containers.seafile = {
    extraVeths.seafiToProxy.hostBridge = "br-proxy-seafi";
    extraVeths.seafiToProxy.localAddress = "192.168.163.3/24";
  };
}
