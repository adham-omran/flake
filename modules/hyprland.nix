{ config, pkgs, lib, ... }:
{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprland
    hyprland-protocols
    hyprland-share-picker
    hyprpaper
    xdg-desktop-portal-hyprland
    waybar
  ];
}
