{ config, pkgs, callPackage, lib, ... }:
{
  # Power configuration for T480
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0=75;
    STOP_CHARGE_THRESH_BAT0=95;

    START_CHARGE_THRESH_BAT1=75;
    STOP_CHARGE_THRESH_BAT1=95;

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };
}
