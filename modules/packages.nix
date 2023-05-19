{ config, pkgs, callPackage, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    cmatrix
    libsForQt5.okular
  ];
}
