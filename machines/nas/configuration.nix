{ config, pkgs, ... }:

{
  imports = [
    ../../hardware-configuration.nix

    ../../profiles/cli.nix
    ../../profiles/gui.nix
    ../../profiles/gui-minimize.nix

    # ../../profiles/hardware.nix
    ../../profiles/users.nix

    ./services.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Bratislava";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp0s3";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  environment.systemPackages = with pkgs; [
     wget
     firefox
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      # grafana
      5049

      # minidlna
      8200

      # gitea
      5022 5080
    ];
    allowedUDPPorts = [ 1900 ];

    interfaces = {
      "ve-prometheus".allowedTCPPorts = [
        # allow to scrape data from prometheus node exporter
        9007
      ];
    };
  };

  system.stateVersion = "21.11";
}

