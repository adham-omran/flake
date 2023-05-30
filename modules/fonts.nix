{ config, pkgs, callPackage, lib, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      fira-code
      fira-code-symbols
      scheherazade-new

      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese

      vazir-fonts
    ];

    fontconfig = {
      defaultFonts = {
	serif = [ "Noto Sans" "Noto Sans Arabic"];
	sansSerif = [ "Noto Sans" "Noto Sans Arabic" ];
	monospace = [ "Fira Code" ];
      };
    };
  };
}
