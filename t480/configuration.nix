{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  networking.hostName = "t480";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Baghdad";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver = {
    enable = true;
    layout = "us";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager = {
    gnome.enable = true;
    plasma5.enable = false;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  programs.dconf.enable = true;
  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
    ];

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

  programs.hyprland.enable = true;
  programs.browserpass.enable = true;
  programs.firefox.nativeMessagingHosts.browserpass = true;
  programs.light.enable = true;
  security.polkit.enable = true;

  services.xserver.wacom.enable = true;
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
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
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [
      "networkmanager" "wheel" "adbusers" "video"
      "docker" "libvirtd" "lp" "scanner" "audio"
    ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.fish;
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.allowedUDPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.enable = true;
  environment.systemPackages = with pkgs; [
    # packages from home-manager
    vnstat
    nil
    mpv
    ffmpeg
    qpwgraph
    playerctl
    ncmpcpp
    clojure
    babashka
    leiningen
    clojure-lsp
    graalvm-ce
    multimarkdown
    activitywatch
    imagemagick
    lilypond
    ncdu
    mysql80
    awscli2

    scream
    zoom-us

    mpc-cli

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
    git
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
    frescobaldi
    vlc
    nodejs_20

    google-chrome
    geckodriver

    obs-studio
    foliate

    zulip
    telegram-desktop
    spotify
    paper-gtk-theme
    pop-gtk-theme
    gnome.adwaita-icon-theme
    arandr
    flameshot
    scrot
    xclip
    xsel
    feh
    dunst
    rofi
    ffcast
    xss-lock
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

    (python3.withPackages(ps: with ps; [ pandas requests
                                         epc orjson
                                         sexpdata six
                                         setuptools paramiko
                                         rapidfuzz
                                       ]))

    hyprpaper
    canon-cups-ufr2
    OVMFFull
    slstatus
    st
    surf
    tabbed
    dmenu
    unzip
    cmatrix
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
  services.vnstat.enable = true;
  services.mpd.user = "userRunningPipeWire";
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
  services.kanata.enable = true;
  services.kanata.package = pkgs.kanata;

  services.kanata.keyboards.usb.devices = [
    "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd" ## external keyboard
    "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
  ];

  services.kanata.keyboards.usb.config = ''
  (defvar
    tap-timeout   150
    hold-timeout  150
    tt $tap-timeout
    ht $hold-timeout
  )

  (defalias
    qwt (layer-switch qwerty)
    col (layer-switch colemak)
    a (tap-hold $tt $ht a lmet)
    r (tap-hold $tt $ht r lalt)
    s (tap-hold $tt $ht s lctl)
    t (tap-hold $tt $ht t lsft)

    n (tap-hold $tt $ht n rsft)
    e (tap-hold $tt $ht e rctl)
    i (tap-hold $tt $ht i ralt)
    o (tap-hold $tt $ht o rmet)

  )

  (defsrc
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt    rctl
  )

  (deflayer colemak
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    f    p    g    j    l    u    y    ;    [    ]    \
      caps @a   @r   @s  @t    d    h   @n   @e   @i    @o    '    ret
      lsft z    x    c    v    b    k    m    ,    .    /    rsft
      lctl lmet lalt           spc            @qwt    rctl
  )

  (deflayer qwerty
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            @col    rctl
  )
  '';
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
    programs.tmux = {
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
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;

    settings = {
      START_CHARGE_THRESH_BAT0=75;
      STOP_CHARGE_THRESH_BAT0=95;

      START_CHARGE_THRESH_BAT1=75;
      STOP_CHARGE_THRESH_BAT1=95;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  virtualisation = {
    docker.enable = true;
    lxd.enable = true;
    libvirtd.enable = true;
  };

  programs.adb.enable = true;
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
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.extraConfig = ''
  DefaultTimeoutStopSec=10sec
  '';
}
