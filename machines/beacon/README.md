beacon
======

## Building and deploying as non-root

Test - deploy running only, without making it boot setup:

```shell
sudo nixos-rebuild test -I nixos-config=./machines/beacon/configuration.nix
```

Deploy - make it startup setup on boot:

```shell
sudo nixos-rebuild boot -I nixos-config=./machines/beacon/configuration.nix
```
