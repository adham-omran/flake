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
    xkb.layout = "us";
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
  };

  programs.hyprland.enable = true;
  programs.browserpass.enable = true;
  programs.firefox.nativeMessagingHosts.browserpass = true;
  programs.light.enable = true;
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
  programs.fish.enable = true;
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
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.allowedUDPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353];
  networking.firewall.enable = true;
  systemd.packages = with pkgs; [cloudflare-warp];
  systemd.targets.multi-user.wants = [ "warp-svc.service" ];
  environment.systemPackages = with pkgs; [
    # Brave
    brave
    # Moonlight
    moonlight-qt
    # corefonts
    corefonts

    # pomodoro
    gnome.pomodoro
    cloudflare-warp
    # packages from home-manager
    nil
    mpv
    ffmpeg
    clojure
    babashka
    clojure-lsp
    graalvm-ce
    multimarkdown
    imagemagick
    ncdu
    awscli2
    zoom-us
    ripgrep
    texlive.combined.scheme-full
    poppler_utils
    hunspell
    hunspellDicts.en_US
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
    gnome.adwaita-icon-theme
    scrot
    xclip
    xsel
    feh
    dunst
    rofi
    ffcast
    networkmanagerapplet
    # cliphist
    # foot
    # sway-contrib.grimshot
    # fuzzel
    # wf-recorder
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
    gnome3.adwaita-icon-theme  # default gnome cursors
    # swaylock
    # swayidle
    # grim         # screenshot functionality
    # slurp        # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    # bemenu       # wayland clone of dmenu
    # mako         # notification system developed by swaywm maintainer
    # wdisplays    # tool to configure displays

    xdg-utils
    wl-clipboard

    (python3.withPackages(ps: with ps; [ pandas requests
                                         epc orjson
                                         sexpdata six
                                         setuptools
                                         paramiko
                                         pyautogui
                                         rapidfuzz
                                       ]))

    canon-cups-ufr2
    OVMFFull
    unzip
    rsync

    openssl
    pinentry

    syncthing
    killall
    virt-manager
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnome.gnome-tweaks
    ((emacsPackagesFor emacs-git).emacsWithPackages (epkgs:
      [
        epkgs.vterm
        epkgs.jinx
      ]))
  ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  programs.sway = {
    enable = false;
    wrapperFeatures.gtk = true;
  };

  services.vnstat.enable = true;
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
    settings.substituters = [ "https://aseipp-nix-cache.freetls.fastly.net" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
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

  networking.extraHosts =
  ''
  '';

  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "a5143ff8b6be9201f6b7aabe209a4c2a4a832ae3"; # change the revision
    }))
  ];
}
