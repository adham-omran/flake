{ config, pkgs, callPackage, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
      ./modules/virtualization.nix
      ./modules/packages.nix
      ./modules/kanata.nix
      ./modules/gnome.nix
      ./modules/fonts.nix
      ./modules/power.nix
      ./modules/overlays.nix
      ./modules/tmux.nix
      ./modules/mpd.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Baghdad";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver = {
    enable = true;
    layout = "us";
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      i3status
      i3lock
      i3blocks
    ];
  };
  services.picom = {
    enable = true;
    vSync = true;
    opacityRules = [
      "85:class_g = 'XTerm'"
    ];
  };
  programs.light.enable = true;
  security.polkit.enable = true;

  services.xserver.wacom.enable = true;
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;

  services.emacs = {
    package = pkgs.emacsUnstable;
    enable = true;
  };

  services.syncthing = {
    enable = true;
    user = "adham";
    configDir = "/home/adham/.config/syncthing";
  };

  services.blueman.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.users.adham = {
    isNormalUser = true;
    description = "adham";
    extraGroups = [
      "networkmanager" "wheel" "adbusers" "video" "docker"
    ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };

  ## Related to Wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };
  services.openssh.enable = true;
  system.stateVersion = "23.05";
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
}
