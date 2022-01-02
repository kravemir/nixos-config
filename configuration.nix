{ config, ... }:

{
  imports = [
    ./machines/nas/configuration.nix
  ];

  boot.initrd.luks.devices = {
    "enc-md1".device = "/dev/disk/by-uuid/c09db7a6-33ea-4967-a8f1-7fda68e6cb95";
    "enc-md2".device = "/dev/disk/by-uuid/62381011-590d-4e40-aa22-12fdcfc98b71";
    "enc-sdd".device = "/dev/disk/by-uuid/776c8c86-e8ac-4709-9f1c-7a3862b9a527";
  };
}

