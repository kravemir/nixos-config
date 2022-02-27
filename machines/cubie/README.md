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
