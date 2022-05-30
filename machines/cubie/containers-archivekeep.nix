{ lib, config, pkgs, ... }:

{
  containers.archivekeep = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }:
    let
      archivekeep = pkgs.callPackage ../../pkgs/archivekeep {};
    in
    {
      systemd.services = let
        securityOptions = {
          ProtectHome = true;
          PrivateUsers = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" ];
        };
      in {
        archivekeep = {
          enable = true;

          serviceConfig = securityOptions // {
            User        = "archivekeep";
            Group       = "archivekeep";

            StateDirectory = "archivekeep";
            RuntimeDirectory = "archivekeep";
            LogsDirectory = "archivekeep";
            ConfigurationDirectory = "archivekeep";
            WorkingDirectory = "/var/lib/archivekeep";

            ExecStart = "${archivekeep}/bin/archivekeep-server run --http-public-path /archivekeep";
          };

          preStart = ''
            mkdir -p /var/lib/archivekeep/data
          '';

          wantedBy = [ "multi-user.target" ];
        };
      };

      users.users.archivekeep = {
        uid = 2003;
        group = "archivekeep";
        description = "ArchiveKeep Service";
        isSystemUser = true;
      };

      users.groups.archivekeep = {
        gid = 2003;
      };


      networking.firewall.allowedTCPPorts = [
        4202
        24202
      ];

      environment.systemPackages = [
        archivekeep
      ];
    };

    bindMounts = {
      "/var/lib/archivekeep" = {
        hostPath = "/storage/ssddata/archivekeep";
        isReadOnly = false;
      };
      "/var/lib/archivekeep/data/repositories" = {
        hostPath = "/storage/hdddata/archivekeep/data/repositories";
        isReadOnly = false;
      };
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.43";

    forwardPorts = [
      {
        containerPort = 24202;
        hostPort = 24202;
        protocol = "tcp";
      }
    ];
  };
}
