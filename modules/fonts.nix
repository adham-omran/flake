{ config, pkgs, callPackage, lib, ... }:
{
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    fira-code
    fira-code-symbols
    scheherazade-new
    # For SwayWM
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];
}
