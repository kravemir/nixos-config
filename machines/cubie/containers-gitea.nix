{ config, pkgs, ... }:

{
  containers.gitea = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      services.sshd.enable = true;
      services.openssh.hostKeys = [
        {
          bits = 4096;
          path = "/var/lib/gitea/sshd/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/var/lib/gitea/sshd/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];

      services.gitea = {
        enable = true;
        user = "git";

        settings.server = {
          ROOT_URL = "http://cubie.home.kravemir.org/gitea";
          HTTP_PORT = 5080;
          SSH_PORT = 5022;
        };

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

      users.groups.gitea = {
        gid = 2001;
      };

      networking.firewall.allowedTCPPorts = [
        22
        5080
      ];

      system.stateVersion = "22.05";
    };

    bindMounts = {
      "/var/lib/gitea" = {
        hostPath = "/storage/ssddata/gitea";
        isReadOnly = false;
      };
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.51";

    forwardPorts = [
      {
        containerPort = 22;
        hostPort = 5022;
        protocol = "tcp";
      }
    ];
  };
}
