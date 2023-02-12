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
  environment.etc."xdg/waybar/config".text = (builtins.readFile ../etc/xdg/waybar/config);
}
