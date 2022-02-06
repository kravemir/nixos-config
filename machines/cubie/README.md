# Cubie

Network attached CUBE for backups storage and experiments.

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
