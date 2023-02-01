{ config, pkgs, lib,  ... }:

{
  # for some reason doesn't work well after upgrade
  boot.plymouth.enable = lib.mkForce false;

  # for early KMS
  boot.initrd.availableKernelModules = [ "amdgpu" ];

  # use just amdgpu driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.xserver.logFile = null;
  services.xserver.exportConfiguration = true;

  services.xserver.deviceSection = ''
          Option "DRI" "3"
          Option "TearFree" "true"
          Option "VariableRefresh" "true"
  '';

  systemd.services.powerdownDiscreteGPU = {
    description = "Fully power down discrete GPU to make system more quiet";

    wantedBy = [ "default.target" ];
    wants = [ "display-manager.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";

      ExecStart = ''
        ${pkgs.bash}/bin/bash -c 'set -e; shopt -s nullglob; echo 1 | tee /sys/bus/pci/devices/0000:03:00.*/remove; ${pkgs.pciutils}/bin/lspci; sleep 5s'
      '';
    };
  };
}

