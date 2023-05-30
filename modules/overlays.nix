{ config, pkgs, callPackage, lib, ... }:
{
  nixpkgs.overlays = [

(import (builtins.fetchTarball {
    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    sha256 = "1m7qzrg7cgsf7l4caz71q1yjngyr48z9n8z701ppbdzk66ydfjfm";
  }))
];

}
