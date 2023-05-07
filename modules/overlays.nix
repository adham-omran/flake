{ config, pkgs, callPackage, lib, ... }:
{
  nixpkgs.overlays = [

    # Waybar overlay for the icons
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
}
