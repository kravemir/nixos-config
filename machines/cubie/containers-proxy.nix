{ config, pkgs, ... }:

{
  containers.proxy = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      # TODO: doesn't work well with dnsProvider = "manual"
      #
      # security.acme = {
      #   acceptTerms = true;
      #   email = "kravec.miroslav@gmail.com";
      #
      #   certs."cubie.home.kravemir.org" = {
      #     domain = "cubie.home.kravemir.org";
      #     dnsProvider = "manual";
      #
      #     credentialsFile = pkgs.writeText "cert-env.txt" "";
      #   };
      # };

      users.users.acme = {
        uid = 2005;
        group = "acme";
        description = "ACME Service";
        isSystemUser = true;
      };

      users.groups.acme = {
        gid = 2005;
      };

      environment.systemPackages = with pkgs; [
        lego
      ];
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
  };
}
