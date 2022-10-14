{ config, pkgs, lib,  ... }:

{
  # use default location, instead of "/dev/null"
  services.xserver.logFile = null;

  services.xserver.exportConfiguration = true;

  # make dedicated GPU primary to prevent 1 FPS bug
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

  services.xserver.displayManager = {
    # connect APU outputs (eDP, HDMI)
    setupCommands   = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
    sessionCommands = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
  };
}

