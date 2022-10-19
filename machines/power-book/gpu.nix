{ config, pkgs, lib,  ... }:

{
  services.xserver.videoDrivers = [
    # modesetting driver contains fix for 1 FPS but on outputs attached to non-primary-GPU
    # Fix reported in AMDGPU https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/issues/37
    # Fix merged in https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/merge_requests/75
    # Fix not yet realeased
    "modesetting"
  ];

  # use default location, instead of "/dev/null"
  services.xserver.logFile = null;

  services.xserver.exportConfiguration = true;

  services.xserver.displayManager = {
    # connect APU outputs (eDP, HDMI)
    setupCommands   = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0;
      ${pkgs.xorg.xrandr}/bin/xrandr --auto;
    '';
    sessionCommands = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
  };

  # make dedicated GPU primary for better performance on USB-C output (attached to dedicated GPU)
  services.xserver.config = ''
      Section "ServerLayout"
          Identifier "layout"
          Screen 0 "dedicated"
          Inactive "apu"
      EndSection

      Section "OutputClass"
          Identifier  "AMD"
          Driver      "modesetting"

          Option      "DRI" "3"
          Option      "TearFree" "true"
          Option      "VariableRefresh" "true"
      EndSection

      Section "Device"
          Identifier  "dedicated"
          Driver      "modesetting"
          BusID       "PCI:3:0:0"

          Option      "PrimaryGPU" "yes"
      EndSection

      Section "Screen"
          Identifier  "dedicated"
          Device      "dedicated"

          DefaultDepth    24
      EndSection

      Section "Device"
          Identifier  "apu"
          Driver      "modesetting"
          BusID       "PCI:7:0:0"
      EndSection

      Section "Screen"
          Identifier  "apu"
          Device      "apu"

          DefaultDepth    24
      EndSection
  '';

  specialisation."amdgpu-on-dedicated" = {
    configuration = {
      services.xserver.videoDrivers = [
        "amdgpu"
      ];

      # make dedicated GPU primary to prevent 1 FPS bug on USB-C output
      # https://gitlab.freedesktop.org/xorg/xserver/-/issues/1028
      services.xserver.config = lib.mkForce ''
          Section "ServerLayout"
              Identifier "layout"
              Screen 0 "dedicated"
              Inactive "apu"
          EndSection

          Section "OutputClass"
              Identifier  "AMD"
              Driver      "amdgpu"

              Option      "DRI" "3"
              Option      "PrimaryGPU" "yes"
              Option      "TearFree" "true"
              Option      "VariableRefresh" "true"
          EndSection

          Section "Device"
              Identifier  "dedicated"
              Driver      "amdgpu"
              BusID       "PCI:3:0:0"

              Option      "PrimaryGPU" "yes"
          EndSection

          Section "Screen"
              Identifier  "dedicated"
              Device      "dedicated"

              DefaultDepth    24
          EndSection

          Section "Device"
              Identifier  "apu"
              Driver      "amdgpu"
              BusID       "PCI:7:0:0"
          EndSection

          Section "Screen"
              Identifier  "apu"
              Device      "apu"

              DefaultDepth    24
          EndSection
      '';
    };
  };
}

