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
      sha256 = "1snqf7y0254w3n49mbcihvyijlpq8pw3ad00h5ppz76xwkd2fnlm";
    }))
  ];
}
