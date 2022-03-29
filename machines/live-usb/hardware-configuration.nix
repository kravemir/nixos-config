# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/aef1330c-ce32-4ce2-9d66-ec43826c960d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/dd58d51e-2781-4f23-a352-642e37053983";
      fsType = "ext4";
    };

  fileSystems."/boot/EFI" =
    { device = "/dev/disk/by-uuid/68A3-C738";
      fsType = "vfat";
    };

  fileSystems."/media/data" =
    { device = "/dev/disk/by-uuid/7dbe8e2b-bbef-4eda-bb0a-e84aca9695ea";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."enc-data".device = "/dev/disk/by-uuid/56ee9dd2-c9fc-44d8-b5b5-87f024a031d6";

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}