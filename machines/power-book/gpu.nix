{ config, pkgs, lib,  ... }:

{
  # make dedicated GPU primary to prevent 1 FPS bug
  # https://gitlab.freedesktop.org/xorg/xserver/-/issues/1028
  services.xserver.config = ''
      Section "ServerLayout"
          Identifier "layout"
          Screen 0 "amdgpu"
          Inactive "apu"
      EndSection

      Section "Device"
          Identifier  "amdgpu"
          Driver      "modesetting"
          BusID       "PCI:3:0:0"
          Option      "DRI" "3"
          Option      "PrimaryGPU" "yes"
          Option      "TearFree" "true"
          Option      "VariableRefresh" "true"
      EndSection

      Section "Screen"
          Identifier "amdgpu"
          Device "amdgpu"
      EndSection

      Section "Device"
          Identifier  "apu"
          Driver      "modesetting"
          BusID       "PCI:7:0:0"
      EndSection

      Section "Screen"
          Identifier  "apu"
          Device      "apu"
          Option      "TearFree" "true"
          Option      "VariableRefresh" "true"
      EndSection
  '';

  services.xserver.displayManager = {
    # connect APU outputs (eDP, HDMI)
    setupCommands   = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
    sessionCommands = "${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0";
  };
}

