{ config, pkgs, ... }:

{
  containers.ldap = {
    autoStart = true;
    ephemeral = true;

    config = { lib, config, pkgs, ... }: {
      services.openldap = {
        enable = true;

        urlList = [
          "ldap:///"
          "ldapi:///"
        ];

        settings.attrs = {
          olcAuthzRegexp = [
            ''{0}"gidnumber=0\+uidnumber=0,cn=peercred,cn=external,cn=auth" "cn=config"''
          ];
        };

        settings.children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            #"${pkgs.openldap}/etc/schema/nis.ldif"
          ];

          "olcDatabase={0}config" = {
            attrs = {
              objectClass = "olcDatabaseConfig";
              olcDatabase = "{0}config";
              olcAccess = [
                ''{0}to dn.subtree="cn=config"
                     by dn.base="cn=config" write
                     by dn.exact="cn=admin,dc=cubie" read
                     by * none''
                ''{1}to * by * none''
              ];
            };
          };

          "olcDatabase={1}mdb".attrs = {
            objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/db/openldap";
            olcRootDN = "cn=admin,dc=cubie";
            olcSuffix = "dc=cubie";
            olcDbIndex = [
              "objectClass eq"
            ];
            olcAccess = [
              # TODO: shouldn't be publicly readable
              ''{0}to * by * read''
            ];
          };
        };
      };

      networking.hosts = {
        "192.168.140.2" = [ "cubie" ];
      };

      networking.firewall.allowedTCPPorts = [
        389
      ];
    };

    privateNetwork = true;
    hostAddress = "192.168.140.2";
    localAddress = "192.168.140.69";

    bindMounts = {
      # TODO: add bind mounts to preserve DB
    };
  };
}
