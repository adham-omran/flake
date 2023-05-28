# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
      ./modules/waydroid.nix
      ./modules/virtualization.nix
      ./modules/flatpak.nix
      ./modules/packages.nix
      ./modules/kanata.nix
      ./modules/gnome.nix
      ./modules/fonts.nix
      ./modules/power.nix
      ./modules/overlays.nix
      ./modules/sway.nix
      ./modules/tmux.nix
      ./modules/mpd.nix
      # ./modules/kde.nix
    ];



  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Baghdad";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # X11 Wacom
  services.xserver.wacom.enable = true;

  # X11 i3
  services.picom.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      i3status # gives you the default i3 status bar
      i3lock #default i3 screen locker
      i3blocks #if you are planning on using i3blocks over i3status
    ];
  };


  ## sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  ## Until you learn to use home-manager's config style, just configure it like
  ## normal.
  ## programs.sway.package = null;
  programs.light.enable = true;
  security.polkit.enable = true;

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };


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
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is
    # enabled by default, no need to redefine it in your config for now)
    #
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  ## zsh shell
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "video" "docker"];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };

  ## Possibly related to screen sharing
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

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

  # Enable flakes
  nix = {
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

  ## beta cache
  # nix.binaryCaches = [ "https://aseipp-nix-cache.freetls.fastly.net" ];
  nix.settings.substituters = [ "https://aseipp-nix-cache.freetls.fastly.net" ];
  ## nix store optimization
  nix.settings.auto-optimise-store = true;
  ## setup for garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.syncthing = {
    enable = true;
    user = "adham";
    configDir = "/home/adham/.config/syncthing";
  };

}
