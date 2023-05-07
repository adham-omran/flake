{ lib, ... }:
{
  programs.adb.enable = true;
  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };
}
