{ self, config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.kernelModules = [ "amdgpu" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
    xpadneo
  ];
  boot.extraModprobeConfig = ''
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
    # Dictionary for Emacs
    dictd = {
      enable = true;
      DBs = with pkgs.dictdDBs; [
        wiktionary
        wordnet
        fra2eng
        eng2fra
      ];
    };

    # TeamViewer
    teamviewer.enable = true;
    # Sunshine
    sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
    };
    # Remote Desktop for GNOME
    gnome.gnome-remote-desktop.enable = true;
    # Sway option
    gnome.gnome-keyring.enable = true;
    desktopManager.plasma6.enable = false;
    # Ollama
    ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "10.3.1";
      };
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

  # Programs
  programs = {
    msmtp = {
      enable = true;
      accounts = {
        default = {
          auth = true;
          tls = true;
          port = "465";
          tls_starttls = "off";
          from = "mail@adham-omran.com";
          host = "smtp.fastmail.com";
          user = "mail@adham-omran.com";
          passwordeval = "cat /home/adham/.fastmail-pass";
        };
        lists = {
          auth = true;
          tls = true;
          port = "465";
          tls_starttls = "off";
          from = "lists@adham-omran.com";
          host = "smtp.fastmail.com";
          user = "mail@adham-omran.com";
          passwordeval = "cat /home/adham/.fastmail-pass";
        };
        work = {
          auth = true;
          tls = true;
          port = "465";
          tls_starttls = "off";
          from = "adham.a@kapita.iq";
          host = "smtp.gmail.com";
          user = "adham.a@kapita.iq";
          passwordeval = "gpg --quiet --for-your-eyes-only --no-tty --decrypt /home/adham/.password-store/accounts.google.com/adham.a@kapita.iq/app-password/mail.gpg";
        };
      };
    };
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
      enable = false;
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
    hyprland.enable = false;
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

  sound.enable = true;
  security.rtkit.enable = true;

  environment.shells = with pkgs; [ fish ];
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [
      "adbusers"
      "audio"
      "docker"
      "input"
      "jackaudio"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "video"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.fish;
  };

  networking.firewall.allowedUDPPortRanges = [
    { from = 47998; to = 48000; }
    { from = 8000; to = 8010; }
  ];

  networking.firewall.allowedTCPPorts = [
    # barrier
    24800

    # sunshine
    47984
    47989
    47990
    48010

    # TODO: Document service and port.
    # others
    8384
    22000
    25565
    80
    433
    5000
    3000
    8080
    4010
    53
    631
    5353
    80
    443
    1401
  ];

  networking.firewall.allowedUDPPorts = [
    # Barrie Ports
    24800

    # TODO: Document service and port.
    22000
    21027
    25565
    80
    433
    5000
    3000
    8080
    4010
    53
    631
    5353
    53
    1194
    1195
    1196
    1197
    1300
    1301
    1302
    1303
    1400
  ];
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
    # Audio Production
    reaper
    yabridge
    yabridgectl
    guitarix

    # Bitwig
    bitwig-studio

    # team
    teamviewer

    # Barrier
    barrier

    # Brave Browser
    brave

    # android tools, flashing
    android-tools

    # mail
    notmuch
    msmtp

    # moonlight
    moonlight-qt

    # android
    scrcpy

    # ai/ml
    openai-whisper

    # games
    gnubg

    # development
    vscode-fhs

    # Clojure
    babashka
    clojure
    quarto

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
    vlc
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
    mako
    dbus
    foot
    wl-clipboard
    xdg-utils

    # Printing
    canon-cups-ufr2

    (python3.withPackages(ps: with ps; [
      pandas
      requests
      epc
      orjson
      sexpdata
      six
      setuptools
      paramiko
      rapidfuzz
    ]))

    # R
    (rWrapper.override {
      packages = with rPackages;
        [
          ggplot2
          dplyr
          reticulate
        ];
    })

    # Virtualization
    OVMFFull
    swtpm

    # Archives
    p7zip
    unzip

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
    gnome.pomodoro

    ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (epkgs:
      [
        epkgs.vterm
        epkgs.jinx
      ]))

    (aspellWithDicts (dicts: with dicts; [
      ar
      en
      en-computers
      en-science
      es
    ]))
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      ibm-plex
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
      scheherazade-new
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

  system.stateVersion = "24.05";
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
    192.168.0.4        truenas.home.arpa truenas truenas.local
    192.168.122.161    truenas.home.arpa truenas truenas.local
    '';

  musnix.enable = true;

  nixpkgs.overlays = [
    self.inputs.emacs.overlay
  ];
}

# Local Variables:
# jinx-local-words: "DefaultTimeoutStopSec JetBrains Naskh Noto Ss adbusers adham arpa config dmix dmixConfig ga gilgamesh gsettings jackaudio libvirtd loopback lp networkmanager rocm svc syncthing truecolor truenas"
# End:
