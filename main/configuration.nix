{ config, pkgs, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in
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
    layout = "us";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager = {
    gnome.enable = false;
    # requires unstable
    plasma6.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
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

  programs = {
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
      pinentryFlavor = "gnome3";
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

  services.xserver.wacom.enable = true;
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  services.ipp-usb.enable = true;
  hardware.sane.openFirewall = true;
  services.hardware.bolt.enable = true;
  services.tailscale.enable = true;

  services.flatpak.enable = true;
  fonts.fontDir.enable = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.syncthing = {
    enable = true;
    user = "adham";
    configDir = "/home/adham/.config/syncthing";
  };

  services.blueman.enable = true;
  services.dbus.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.shells = with pkgs; [ fish ];
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [
      "networkmanager" "wheel" "adbusers" "video"
      "docker" "libvirtd" "lp" "scanner" "audio" "input"
    ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.fish;
  };
  services.openssh.enable = true;
  services.mullvad-vpn.enable = true;

  networking.firewall.allowedTCPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.allowedUDPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.enable = true;
  systemd.packages = with pkgs; [cloudflare-warp];
  systemd.targets.multi-user.wants = [ "warp-svc.service" ];
  environment.systemPackages = with pkgs; [
    # fonts
    corefonts
    # audio
    reaper
    airwindows-lv2
    # terminal
    tldr
    fzf
    aria
    # applications
    spotify
    # VPN
    mullvad-vpn
    mullvad

    cloudflare-warp
    hugo

    # packages from home-manager
    vnstat
    nil
    mpv
    ffmpeg
    qpwgraph
    clojure-lsp
    multimarkdown
    imagemagick
    ncdu
    mysql80
    awscli2

    zoom-us

    ripgrep
    texlive.combined.scheme-full
    poppler_utils

    hunspell
    hunspellDicts.en_US

    yt-dlp
    gnuplot
    libnotify
    direnv
    gtk3
    graphviz
    openssl
    stow
    tree
    ledger
    neofetch
    bat
    btop
    fd
    dmidecode
    powertop
    wget
    brightnessctl
    pavucontrol
    pass
    element-desktop-wayland
    zeal
    gimp-with-plugins
    qbittorrent
    chromedriver
    zotero
    libreoffice-qt
    anki-bin
    nodejs_20

    google-chrome
    obs-studio
    foliate

    zulip
    telegram-desktop
    spotify
    paper-gtk-theme
    pop-gtk-theme
    gnome.adwaita-icon-theme
    scrot
    xclip
    xsel
    feh
    dunst
    rofi
    ffcast
    networkmanagerapplet
    cliphist
    foot
    sway-contrib.grimshot
    fuzzel
    wf-recorder
    # git
    git
    # Sway
    waybar
    dbus   # make dbus-update-activation-environment available in the path
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    grim         # screenshot functionality
    slurp        # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu       # wayland clone of dmenu
    mako         # notification system developed by swaywm maintainer
    wdisplays    # tool to configure displays

    foot
    wayland
    xdg-utils
    wl-clipboard
    wofi

    (python3.withPackages(ps: with ps; [ pandas requests
                                         epc orjson
                                         sexpdata six
                                         setuptools paramiko
                                         rapidfuzz
                                       ]))

    hyprpaper
    canon-cups-ufr2
    OVMFFull
    unzip
    libsForQt5.okular
    rsync

    openssl
    pinentry
    pinentry-gtk2
    pinentry-gnome
    syncthing
    killall
    virt-manager
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    gnome.gnome-tweaks
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

  environment.variables = {
    DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
  };


  services.vnstat.enable = true;
  services.mpd.user = "userRunningPipeWire";
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
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
  services.power-profiles-daemon.enable = false;

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
  };

  nix.settings.substituters = [ "https://aseipp-nix-cache.freetls.fastly.net" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  hardware.opengl = {
    enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.extraConfig = ''
  DefaultTimeoutStopSec=10sec
  '';

  networking.extraHosts =
  ''
    192.168.0.4      truenas.home.arpa truenas truenas.local
  '';
}
