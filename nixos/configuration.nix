{ config, pkgs, ... }:

let
  myVim = pkgs.vim_configurable.override {
    python = pkgs.python3.withPackages(ps: with ps; [ pynvim ]);
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/common/cpu/intel>
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/pc/ssd>
      /etc/nixos/hardware-configuration.nix
      ./xps15.nix
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
    enableRedistributableFirmware = true;
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
      dpi = 240;
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
    tlp.enable = true;
  };

  environment.variables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    # GUI apps
    bitwarden
    calibre
    chromium
    evince
    firefox
    meld
    slack
    spotify
    transmission-gtk
    vlc

    # CLI apps
    cmus
    myVim
    neovim
    ranger

    # Programming
    clojure
    leiningen
    nodejs-10_x
    (python37.withPackages(ps: with ps; [ pynvim ]))
    ruby

    # Utils
    ag
    arandr
    bar-xft
    chromedriver
    docker-compose
    eternal-terminal
    git
    gnumake
    ncurses.dev
    openvpn
    pavucontrol
    polybar
    postgresql
    rofi
    rxvt_unicode
    scrot
    stow
    unrar
    unzip
    wirelesstools
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
    extraGroups = [ "wheel" "docker" "video" "vboxusers" ];
    uid = 1000;
  };

  system.stateVersion = "19.09";
}
