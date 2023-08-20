{ lib, config, pkgs, ... }:

{
  networking.firewall = pkgs.lib.mkForce {
    enable = true;

    allowedTCPPorts = [
      22

      # for unbound container
      53

      # for iperf3
      5201

      # WARNING: does not filter out forwarded ports !!
    ];

    allowedUDPPorts = [
      # for unbound container
      53
    ];

    interfaces = {
      "ve-prometheus".allowedTCPPorts = [
        # allow to scrape data exposed by prometheus node exporter
        9100
      ];
    };
  };
}

