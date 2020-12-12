{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  xresources.properties = {
    "URxvt.perl-lib" = "${pkgs.urxvt_perls}/lib/urxvt/perl";
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  xsession.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = pkgs.vanilla-dmz;
    size = 64;
  };
}
