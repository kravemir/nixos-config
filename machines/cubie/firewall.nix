{ lib, config, pkgs, ... }:

{
  networking.firewall = pkgs.lib.mkForce {
    enable = true;

    allowedTCPPorts = [
      22

      # WARNING: does not filter out forwarded ports !!
    ];

    interfaces = {
      "ve-prometheus".allowedTCPPorts = [
        # allow to scrape data exposed by prometheus node exporter
        9100
      ];
    };
  };
}

