{ lib, config, pkgs, ... }:

{
  time.timeZone = "Europe/Bratislava";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_NUMERIC= "sk_SK.UTF-8";
      LC_TIME = "sk_SK.UTF-8";
      LC_MONETARY = "sk_SK.UTF-8";
      LC_PAPER = "sk_SK.UTF-8";
      LC_MEASUREMENT = "sk_SK.UTF-8";
    };
  };
}

