{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
 ];
}

