{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  networking.hostName = "gilgamesh";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Baghdad";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    desktopManager =
      {
        gnome.enable = false;
      };
    displayManager.gdm.enable = true;
    xkb.layout = "us";
    wacom.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # services
  services = {
    desktopManager.plasma6.enable = true;
    jack = {
      jackd.enable = true;
      # support ALSA only programs via ALSA JACK PCM plugin
      alsa.enable = false;
      # support ALSA only programs via loopback device (supports programs like Steam)
      loopback = {
        enable = true;
        # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
        #dmixConfig = ''
        #  period_size 2048
        #'';
      };
    };
    ollama = {
      enable = true;
      acceleration = "rocm";
    };
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    ipp-usb.enable = true;
    hardware.bolt.enable = true;
    tailscale.enable = true;
    printing.enable = true;
    flatpak.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    syncthing = {
      enable = true;
      user = "adham";
      configDir = "/home/adham/.config/syncthing";
    };
    blueman.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    openssh.enable = true;
    mullvad-vpn.enable = true;
    vnstat.enable = true;
    power-profiles-daemon.enable = false;
  };
  environment = {
    gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gnome-music
      gnome-terminal
      gedit
      epiphany
      geary
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
    ]);
  };

  # programs
  programs = {
    virt-manager.enable = true;
    tmux = {
      enable = true;

      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''
              set -g default-terminal "xterm-256color"
              set -ga terminal-overrides ",*256col*:Tc"
              set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
              set-environment -g COLORTERM "truecolor"
                '';
    };

    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    firefox.nativeMessagingHosts.browserpass = true;
    fish.enable = true;
    browserpass.enable = true;
    hyprland.enable = true;
    light.enable = true;
    dconf.enable = true;
    adb.enable = true;
  };

  ## Check https://github.com/browserpass/browserpass-extension/issues/338

  security.polkit.enable = true;

  hardware = {
    opengl = {
      enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      openFirewall = true;
    };
    pulseaudio.enable = false;
  };

  fonts.fontDir.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;

  environment.shells = with pkgs; [ fish ];
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [
      "networkmanager" "wheel" "adbusers" "video" "jackaudio"
      "docker" "libvirtd" "lp" "scanner" "audio" "input"
    ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.fish;
  };

  networking.firewall.allowedTCPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.allowedUDPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.enable = true;
  systemd = {
    packages = with pkgs; [cloudflare-warp];
    targets.multi-user.wants = [ "warp-svc.service" ];
    services.NetworkManager-wait-online.enable = false;
    extraConfig = ''
        DefaultTimeoutStopSec=10sec
      '';
  };
  environment.systemPackages = with pkgs; [
    # Wine
    wineWowPackages.stable
    winetricks
    wineWowPackages.waylandFull

    # communication
    slack
    telegram-desktop
    zulip
    hexchat

    # fonts
    corefonts

    # audio
    airwindows-lv2
    ardour
    gxplugins-lv2
    guitarix
    surge
    kid3

    reaper


    # terminal
    aria
    fzf
    tldr

    # utilities
    pciutils
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils

    # applications
    spotify

    # VPN
    cloudflare-warp
    hugo
    mullvad
    mullvad-vpn

    # packages from home-manager
    awscli2
    clojure-lsp
    ffmpeg
    imagemagick
    mpv
    multimarkdown
    mysql80
    ncdu
    nil
    poppler_utils
    qpwgraph
    ripgrep
    texlive.combined.scheme-full
    vnstat
    zoom-us

    # Dictionary
    hunspell
    hunspellDicts.en_US

    anki-bin
    bat
    brightnessctl
    btop
    chromedriver
    cliphist
    direnv
    dmidecode
    dunst
    element-desktop-wayland
    fd
    feh
    ffcast
    foliate
    foot
    fuzzel
    gimp-with-plugins
    gnome.adwaita-icon-theme
    gnuplot
    google-chrome
    graphviz
    gtk3
    killall
    ledger
    libnotify
    libreoffice-qt
    neofetch
    networkmanagerapplet
    nodejs_20
    obs-studio
    openssl
    paper-gtk-theme
    pass
    pavucontrol
    pop-gtk-theme
    powertop
    qbittorrent
    rofi
    scrot
    spotify
    stow
    sway-contrib.grimshot
    tree
    wf-recorder
    wget
    xclip
    xsel
    yt-dlp
    zeal
    zotero
    # git
    git
    # Tiling WM Utilities
    dbus
    foot
    glib # gsettings
    gnome3.adwaita-icon-theme  # default gnome cursors
    grim
    hyprpaper
    slurp
    waybar
    wayland
    wdisplays
    wl-clipboard
    wofi
    xdg-utils

    # Printing
    canon-cups-ufr2

    (python3.withPackages(ps: with ps; [ pandas requests
                                         epc orjson
                                         sexpdata six
                                         setuptools paramiko
                                         rapidfuzz
                                       ]))

    # Virtualization
    OVMFFull

    # Archives
    p7zip
    unzip

    # Plasma 6 Extras
    kdePackages.akonadi
    kdePackages.kontact
    kdePackages.merkuro
    kdePackages.kclock
    kdePackages.krdc
    kdePackages.kcalc
    kdePackages.okular
    kdePackages.skanlite
    kdePackages.skanpage

    # SSH and GPG
    openssl
    pinentry

    # Syncing
    rsync
    syncthing


    # GNOME
    gnome.adwaita-icon-theme
    gnome.gnome-tweaks
    gnomeExtensions.appindicator

    # Emacs
    ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (epkgs:
      [
        epkgs.vterm
        epkgs.jinx
      ]))
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      amiri
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      fira-code
      fira-code-symbols
      scheherazade-new
      jetbrains-mono
      hack-font

      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese

      vazir-fonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans" "Noto Naskh Arabic"];
        sansSerif = [ "Noto Sans" "Noto Naskh Arabic" ];
        monospace = [ "JetBrains Mono" ];
      };
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker.enable = true;
    lxd.enable = true;
    libvirtd.enable = true;
  };

  system.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings.substituters = [ "https://aseipp-nix-cache.freetls.fastly.net" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.extraHosts =
    ''
    192.168.0.4      truenas.home.arpa truenas truenas.local
  '';

  musnix.enable = true;
}
