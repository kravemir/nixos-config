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

        rootUrl = "http://cubie:5080/";

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
        hostPath = "/storage/ssddata/gitea";
        isReadOnly = false;
      };
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.51";

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
}
