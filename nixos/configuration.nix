{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/common/cpu/intel>
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/pc/ssd>
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.grub.configurationLimit = 10;
    # loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    bluetooth.enable = true;
    bumblebee.enable = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.ens1u2u4.useDHCP = true;
  };

  virtualisation.docker.enable = true;

  virtualisation.virtualbox = {
    host.enable = true;
    guest.enable = true;
    host.enableExtensionPack = true;
  };

  programs = {
    fish.enable = true;

    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "dbepggeogbaibhgnhhndojpepiihcmeb"
        "fihnjjcciajhdojfnbdddfaoknhalnja"
        "dpjamkmjmigaoobjbekmfgabipmfilij"
      ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      dpi = 180;
      libinput.enable = true;

      layout = "us";
      xkbVariant = "dvorak";
      xkbOptions = "ctrl:nocaps";
      
      windowManager.xmonad.enable = true;
      windowManager.xmonad.extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };
    };

    fwupd.enable = true;
    kbfs.enable = true;
    keybase.enable = true;
  };

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    bitwarden
    calibre
    chromium
    evince
    firefox
    slack
    spotify
    transmission-gtk
    vlc

    # Programming
    ruby

    git
    (neovim.override {
      vimAlias = true;
    })
    ranger
    stow
    unzip

    ag
    arandr
    bar-xft
    docker-compose
    openvpn
    pavucontrol
    polybar
    rofi
    rxvt_unicode
    xfontsel
    xmobar
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      fantasque-sans-mono
      fira-code
      ubuntu_font_family
    ];
  };

  users.extraUsers.erik = {
    isNormalUser = true;
    home = "/home/erik";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [ "wheel" "docker" "libvirtd" "video" ];
    uid = 1000;
  };

  system.stateVersion = "19.09";
}
