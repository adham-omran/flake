{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  networking.hostName = "marduk";
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
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  programs.dconf.enable = true;
  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
    ];
  };

  programs.browserpass.enable = true;
  programs.firefox.nativeMessagingHosts.browserpass = true;
  programs.light.enable = true;
  security.polkit.enable = true;

  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  services.ipp-usb.enable = true;
  hardware.sane.openFirewall = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;
  fonts.fontDir.enable = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [
      "networkmanager" "wheel" "adbusers" "video"
      "docker" "libvirtd" "lp" "scanner"
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
  networking.firewall.enable = true;
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    btop
    # Sway
    ## Screenshots
    sway-contrib.grimshot
    ## Clipboard history
    cliphist
    ## Edit screenshots
    swappy
    # Themes
    bibata-cursors
    # Network Management
    networkmanager
    # Accounting
    ledger
    # Utilities that use Python
    python3
    # Audio Control GUI
    pavucontrol
    # LSP Server for Nix
    nil
    # Clipboard management
    wl-clipboard
    # Application Menu
    fuzzel
    # Password management
    pass

    hunspellDicts.en_US
    aspell
    aspellDicts.en
    fastfetch
    git
    stow

    grim
    slurp
    wl-clipboard
    canon-cups-ufr2
    rsync
    openssl
    pinentry
    pinentry-gtk2
    pinentry-gnome
    syncthing
    killall

    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    gnome.gnome-tweaks
  ];
  services.emacs = {
    enable = true;
    package = with pkgs; (
      (emacsPackagesFor emacs29-pgtk).emacsWithPackages (
        epkgs: [
          epkgs.vterm
          epkgs.jinx
        ]
      ));
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

  virtualisation = {
    docker.enable = true;
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
    dates = "daily";
    options = "--delete-older-than 3d";
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.extraConfig = ''
  DefaultTimeoutStopSec=10sec
  '';
}

# Local Variables:
# jinx-local-words: "marduk"
# End:
