{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/ssd>
  ];
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  services.thermald.enable = true;
  services.tlp.enable = true;
  services.xserver.libinput = {
    additionalOptions = ''
      Option "PalmDetection" "on"
    '';
  };
}
