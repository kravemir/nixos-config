# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0ed58ac7-e60b-4959-af76-f583e5e86317";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2128-13B1";
      fsType = "vfat";
    };

  fileSystems."/storage/ssddata" =
    { device = "/dev/disk/by-uuid/017f263d-d3a5-44a4-b396-c8a196349751";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

  fileSystems."/storage/hdddata" =
    { device = "/dev/disk/by-uuid/74002430-b880-44dc-badd-c25871f24576";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
      ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8bf9c391-6148-44bc-ba4e-4f56c71a76f8"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
