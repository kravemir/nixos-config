{
  services.gitea = {
    service.restart = "always";

    service.image = "gitea/gitea:1.15.7";
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
}
