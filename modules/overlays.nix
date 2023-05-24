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
      sha256 = "1dp7jp1cdqgfxddpyg31vxw727nhyyzjxr3rf52q2jhwl6492fxy";
    }))
  ];
}
