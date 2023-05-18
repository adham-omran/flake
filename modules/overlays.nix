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
      sha256 = "0q96l4vy34n4csscbmh1kfwafv50zmv75pbbmzm9b0vybr5vfwq3";
    }))
  ];
}
