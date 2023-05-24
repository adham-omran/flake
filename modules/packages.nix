{ config, pkgs, callPackage, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    unzip
    cmatrix
    libsForQt5.okular
    rsync

    mpd
    mpc-cli
    # mopidy
    # mopidy-mopify
    # mopidy-spotify


    openssl
    syncthing
    killall

    ## Hyprland
    hyprland
    hyprland-protocols
    hyprland-share-picker
    xdg-desktop-portal-hyprland

    ## Common to Hyprland & Sway
    waybar

    # GNOME
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    # END OF GNOME

    # Emacs ovrelay
    ((emacsPackagesFor emacsUnstable).emacsWithPackages (epkgs:
      [
        epkgs.vterm
        epkgs.jinx
      ]))
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.0"
  ];
}
