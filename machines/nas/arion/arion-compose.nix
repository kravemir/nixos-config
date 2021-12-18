{
  services.gitea = {
    service.image = "gitea/gitea:1.15.7";
    service.restart = "unless-stopped";
    service.volumes = [ 
      "/storage/data/gitea:/data"
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    service.environment = {
      USER_UID = "1000";
      USER_GID = "1000";
    };
    service.ports = [
      "5080:3000"
      "5022:22"
    ];
  };

  services.minidlna = { config, pkgs, ... }: {
    nixos = {
      useSystemd = true;
    
      configuration.boot.tmpOnTmpfs = true;

      configuration.systemd.services.nscd.enable = false;

      configuration.services.minidlna.enable = true;
      configuration.services.minidlna.announceInterval = 1;
      configuration.services.minidlna.friendlyName = "NAS";
      configuration.services.minidlna.mediaDirs = [
        "A,/storage/data/public/Audio/"
        "V,/storage/data/public/Videos/"
      ];
    };

    service.volumes = [ 
      "/storage/data/public:/storage/data/public:ro"
    ];

    # TODO: do not use lesser secure host network mode
    service.network_mode = "host";

    # TODO: solve multicast forwarding issue
    # service.ports = [
    #   "8200:8200/tcp"
    #   "1900:1900/udp"
    # ];
  };
}
