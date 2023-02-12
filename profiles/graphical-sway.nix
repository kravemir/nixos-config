{ config, pkgs, ... }:

{
  xdg.portal.wlr.enable = true;

  programs.sway = {
    enable = true;

    wrapperFeatures.base = true;
    wrapperFeatures.gtk = true;

    extraPackages = with pkgs; [
      i3status
      i3status-rust
      waybar

      swaylock
      swayidle

      alacritty
      fuzzel

      brightnessctl
      kanshi
      pavucontrol
      pulseaudio
    ];
  };

  programs.seahorse.enable = true;

  environment.etc."sway/config".text = (builtins.readFile ../etc/sway/config);
  environment.etc."i3status.conf".text = (builtins.readFile ../etc/i3status.conf);
  environment.etc."xdg/swayidle/config".text = (builtins.readFile ../etc/xdg/swayidle/config);
  environment.etc."xdg/waybar/config".text = (builtins.readFile ../etc/xdg/waybar/config);

  # see: https://github.com/swaywm/sway/wiki/Systemd-integration
  systemd.user.targets.sway-session = {
    description = "sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.targets.tray = {
    description = "System Tray";
    requires = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.kanshi = {
    bindsTo = [ "sway-session.target" ];
    wantedBy = [ "sway-session.target" ];

    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = "3";

    script = "${pkgs.kanshi}/bin/kanshi";
  };

  systemd.user.services.swayidle = {
    bindsTo = [ "sway-session.target" ];
    wantedBy = [ "sway-session.target" ];

    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = "3";

    script = "${pkgs.swayidle}/bin/swayidle -C /etc/xdg/swayidle/config";

    path = with pkgs; [
      sway
      swaylock
    ];
  };

}
