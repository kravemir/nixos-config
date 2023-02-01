# Cubie

Network attached CUBE - homelab server for backups storage and experiments.

## Setup

Create `/etc/nixos/configuration.nix` with following contents:

```nix
{ config, ... }:

{
  imports = [
    ./machines/cubie/configuration.nix
  ];
}
```

Configure ACME:

1. register at acme-dns:

   -  see https://github.com/joohoi/acme-dns#usage,

2. create `/storage/ssddata/proxy/acme/config/credentials.json`:

   ```json
   {
       "cubie.home.kravemir.org": {
           "allowfrom": [],
           "fulldomain": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx.auth.acme-dns.io",
           "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
           "subdomain": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
           "username": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
       }
   }
   ```

   **SECURITY** - reduce access permissions for credentials:

   ```shell
   chown 2005 /storage/ssddata/proxy/acme/config/credentials.json
   chmod 700 /storage/ssddata/proxy/acme/config/credentials.json
   ```

3. restart proxy service:

   ```shell
   machinectl reboot proxy
   ```


Configure Mikrotik router to use DNS resolver when machine is online:

```
/ip dhcp-server network set 0 dns-server=192.168.88.1

/tool netwatch add \
    comment="Use DNS when up" \
    host=192.168.88.154 \
    interval=1s \
    down-script="/ip dhcp-client set 0 use-peer-dns=yes; /ip dns set servers=\"\"; /ip dns cache flush" \
    up-script="/ip dhcp-client set 0 use-peer-dns=no; /ip dns set servers=192.168.88.154; /ip dns cache flush"
```

## Operations

### LDAP - management

To set admin password, generate new password hash with `slappasswd`, and then:

```bash
nixos-container root-login ldap

ldapmodify -H ldapi:/// -Y EXTERNAL -D 'cn=config' << EOF
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: ___put_generated_SSHA_here___
EOF
```

Afterwards, to setup DB contents create `contents.ldif` file:

```
dn: dc=cubie
dc: cubie
o: Homelab Cubie
objectClass: organization
objectClass: dcObject

dn: ou=Users,dc=cubie
objectClass: organizationalUnit
ou: Users
```

And import it using `ldapadd`:

```bash
ldapadd -x -H ldap://192.168.140.69 -D cn=admin,dc=cubie -W -f contents.ldif
```
