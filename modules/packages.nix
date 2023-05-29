{ config, pkgs, callPackage, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    unzip
    cmatrix
    libsForQt5.okular
    rsync

    mpd
    mpc-cli

    openssl
    pinentry
    pinentry-gtk2
    syncthing
    killall

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
