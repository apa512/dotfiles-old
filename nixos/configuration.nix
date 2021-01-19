{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
  myVim = pkgs.vim_configurable.override {
    python = pkgs.python3.withPackages(ps: with ps; [ pynvim ]);
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./xps15.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.grub.configurationLimit = 10;
    # loader.efi.canTouchEfiVariables = true;

    supportedFilesystems = [ "ntfs" ];

    # kernelPackages = pkgs.linuxPackages_5_7;
  };

  time.timeZone = "Europe/Nicosia";

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    bluetooth.enable = true;
    enableRedistributableFirmware = true;
  };

  console = {
    font = "Lat2-Terminus32";
    keyMap = "dvorak";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.ens1u2u4.useDHCP = true;
    extraHosts = ''
      127.0.0.1 ducktype.local
      127.0.0.1 api.ducktype.local
      127.0.0.1 dashboard.ducktype.local
    '';
    firewall.enable = false;
    firewall.allowedUDPPorts = [ 5353 427 ];
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  programs = {
    fish.enable = true;

    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "dbepggeogbaibhgnhhndojpepiihcmeb"
        "dpjamkmjmigaoobjbekmfgabipmfilij"
        "fihnjjcciajhdojfnbdddfaoknhalnja"
        "nngceckbapebfimnlniiiahkandclblb"
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
      dpi = 220;
      libinput.enable = true;

      layout = "us";
      xkbVariant = "dvorak";
      xkbOptions = "ctrl:nocaps";

      windowManager.xmonad.enable = true;
      windowManager.xmonad.extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };

    plex = {
      enable = true;
      group = "users";
      user = "erik";
      openFirewall = true;
    };

    avahi.enable = true;

    pcscd.enable = true;
    pcscd.plugins = [ pkgs.acsccid ];

    gnome3.gnome-keyring.enable = true;

    openvpn.servers = {
      se = {
        config = (builtins.readFile ./expressvpn/my_expressvpn_sweden_udp.ovpn);
        autoStart = false;
        authUserPass = {
          username = secrets.expressvpn.username;
          password = secrets.expressvpn.password;
        };
      };

      ee = {
        config = (builtins.readFile ./expressvpn/my_expressvpn_estonia_udp.ovpn);
        autoStart = false;
        authUserPass = {
          username = secrets.expressvpn.username;
          password = secrets.expressvpn.password;
        };
      };

      je = {
        config = (builtins.readFile ./expressvpn/my_expressvpn_jersey_udp.ovpn);
        autoStart = false;
        authUserPass = {
          username = secrets.expressvpn.username;
          password = secrets.expressvpn.password;
        };
      };

      ua = {
        config = (builtins.readFile ./expressvpn/my_expressvpn_ukraine_udp.ovpn);
        autoStart = false;
        authUserPass = {
          username = secrets.expressvpn.username;
          password = secrets.expressvpn.password;
        };
      };

      us = {
        config = (builtins.readFile ./expressvpn/my_expressvpn_usa_-_san_francisco_udp.ovpn);
        autoStart = false;
        authUserPass = {
          username = secrets.expressvpn.username;
          password = secrets.expressvpn.password;
        };
      };
    };

    fwupd.enable = true;
    kbfs.enable = true;
    keybase.enable = true;
  };

  environment.variables.EDITOR = "vim";
  environment.variables.VISUAL = "vim";

  environment.systemPackages = with pkgs; [
    # GUI apps
    _1password
    bitwarden
    calibre
    chromium
    displaycal
    evince
    firefox
    gpodder
    gsettings-desktop-schemas
    mailspring
    meld
    qdigidoc
    remmina
    slack
    spotify
    transmission-gtk
    vlc

    # CLI apps
    # beets
    cmus
    myVim
    neovim
    ranger

    # Programming
    clojure
    leiningen
    nodejs-10_x
    (python3.withPackages(ps: with ps; [ pynvim ]))
    ruby
    rustup
    yarn

    # Utils
    ag
    arandr
    bar-xft
    busybox
    calc
    chromedriver
    cifs-utils
    clj-kondo
    direnv
    docker-compose
    ecryptfs
    ecryptfs-helper
    eternal-terminal
    # ffmpeg-full
    file
    git
    gnumake
    hlint
    httpie
    ncurses.dev
    openvpn
    pavucontrol
    polybar
    postgresql
    rofi
    rxvt_unicode
    scrot
    stow
    unar
    unrar
    unzip
    wirelesstools
    xfontsel
    xmobar
    zip
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      fantasque-sans-mono
      fira-code
      jetbrains-mono
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

  nix.trustedUsers = [ "root" "erik" ];

  system.stateVersion = "20.09";
}
