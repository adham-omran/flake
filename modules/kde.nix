{ config, pkgs, callPackage, lib, ... }:
{
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  ## Remove some kde apps
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
  ];
}
