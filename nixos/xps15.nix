{ config, pkgs, ... }:

{
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  services.thermald.enable = true;
}
