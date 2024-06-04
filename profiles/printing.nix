{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
  ];

  services.printing.browsing = true;

  # for WiFi printers
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns4 = true;

  # for scanning
  hardware.sane.enable = true;
}

