# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
      ./modules/waydroid.nix
      ./modules/docker.nix
      ./modules/flatpak.nix
      # ./mpd.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Baghdad";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # X11 Wacom
  services.xserver.wacom.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  ##se SWAY STUFF
  programs.sway.enable = true;
  ## Until you learn to use home-manager's config style, just configure it like
  ## everyone else.
  # programs.sway.package = null;
  programs.light.enable = true;
  security.polkit.enable = true;
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  ## GNOME
  services.xserver.displayManager.startx.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  programs.dconf.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    nautilus # Files, replaced with Nemo
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
  ## END OF GNOME

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable thunderbolt
  services.hardware.bolt.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  ## zsh shell
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "video" "docker"];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ## remove some kde apps
  # environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  #   elisa
  # ];

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "adham";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    openssl
    wget
    syncthing
    killall
    hyprland
    hyprland-protocols
    hyprland-share-picker
    xdg-desktop-portal-hyprland
    waybar
    powertop
    plasma5Packages.plasma-thunderbolt
    # GNOME
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    # END OF GNOME
    ((emacsPackagesFor emacsUnstable).emacsWithPackages (epkgs:
      [
        epkgs.vterm
        epkgs.jinx
      ]))
  ];
  nixpkgs.overlays = [
    ## overlay waybar for the icons
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })

    (import (builtins.fetchTarball {
      ## overlay emacs for latest release
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "1jscdcq38zqgpjpbp2j34a8hn65sywxz294nnylba35fij4an80w";
    }))
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

    ## waydroid config
  # virtualisation = {
  #   waydroid.enable = true;
  #   lxd.enable = true;
  # };

  nix =
    {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
    };

  programs.hyprland = {
    enable = true;
  };

  services.emacs = {
    package = pkgs.emacsUnstable;
    enable = true;
  };

  services.tailscale.enable = true;


  ## power config for T480
  # services.tlp.enable = true;
  # services.tlp.settings = {
  #   START_CHARGE_THRESH_BAT0=75;
  #   STOP_CHARGE_THRESH_BAT0=80;

  #   START_CHARGE_THRESH_BAT1=75;
  #   STOP_CHARGE_THRESH_BAT1=80;
  # };

  ## nix store optimization
  nix.settings.auto-optimise-store = true;
  ## setup for garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ## keyboard setup
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

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    fira-code
    fira-code-symbols
    scheherazade-new
    # For SwayWM
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];

  programs.adb.enable = true;

  services.syncthing = {
    enable = true;
    user = "adham";
    configDir = "/home/adham/.config/syncthing";
  };

}
