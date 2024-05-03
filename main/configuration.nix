{ config, pkgs, lib, ... }:
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
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    options vfio-pci ids=1002:73ff,1002:ab28
  '';

  # These modules are required for PCI passthrough, and must come before early modesetting stuff
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" ];

  boot.supportedFilesystems = [ "ntfs" ];

  networking = {
    hostName = "gilgamesh";
    networkmanager.enable = true;
  };
  time.timeZone = "Asia/Baghdad";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    xkb.layout = "us";
    wacom.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
    AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
    AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config";
    HISTFILE = "$XDG_STATE_HOME/bash/history";
    GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose";
  };

  # services
  services = {
    # Sway option
    gnome.gnome-keyring.enable = true;
    desktopManager.plasma6.enable = false;
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
    noisetorch.enable = true;
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
      pinentryPackage = pkgs.pinentry-gnome3;
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

  networking.firewall.allowedTCPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353
                                          80 443 1401];
  networking.firewall.allowedUDPPorts = [ 25565 80 433 5000 3000 8080 4010 53 631 5353
                                          53 1194 1195 1196 1197 1300 1301 1302 1303 1400];
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
    # android
    scrcpy

    # ai/ml
    openai-whisper

    # games
    gnubg
    lutris

    # development
    vscode-fhs

    # sunshine
    sunshine

    # Clojure
    babashka
    clojure
    quarto

    # ricing
    eww

    # photography
    darktable

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
    audacity
    sonobus
    musescore
    yabridge
    yabridgectl
    airwindows-lv2
    ardour
    gxplugins-lv2
    guitarix
    surge-XT
    kid3
    reaper

    # terminal
    neovim
    xdg-ninja
    jq
    radeontop
    aria
    fzf
    tldr
    ncdu
    nil

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

    # media
    spotify

    # packages from home-manager
    awscli2
    clojure-lsp
    ffmpeg
    imagemagick
    mpv
    multimarkdown
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
    # dnkl Utilities
    foot
    fuzzel
    fnott
    wbg

    # Screenshot
    gimp
    swappy

    gnuplot
    google-chrome
    graphviz
    gtk3
    killall
    ledger
    libnotify
    libreoffice-qt
    fastfetch
    networkmanagerapplet
    nodejs_20

    openssl
    pass
    pavucontrol
    pop-gtk-theme
    powertop
    qbittorrent
    rofi
    scrot
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
    xfce.thunar
    mako
    dbus
    foot
    glib # gsettings
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
    swtpm

    # Archives
    p7zip
    unzip

    # Plasma 6 Extras
    # kdePackages.kamoso
    # kdePackages.akonadi
    # kdePackages.kontact
    # kdePackages.merkuro
    # kdePackages.kclock
    # kdePackages.krdc
    # kdePackages.kcalc
    # kdePackages.okular
    # kdePackages.skanlite
    # kdePackages.skanpage

    # SSH and GPG
    openssl
    pinentry

    # Syncing
    rsync
    syncthing
    rclone


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
  users.groups.libvirtd.members = [ "root" "adham"];

  virtualisation = {
    docker.enable = true;
    lxd.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
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

  # Remove limits for Lutris
  security.pam.loginLimits = [
    {
      domain = "adham";
      item = "nofile";
      type = "hard";
      value = "524288";
    }
  ];
}

# Local Variables:
# jinx-local-words: "DefaultTimeoutStopSec JetBrains Naskh Noto Ss adbusers adham arpa config dmix dmixConfig ga gilgamesh gsettings jackaudio libvirtd loopback lp networkmanager rocm svc syncthing truecolor truenas"
# End:
