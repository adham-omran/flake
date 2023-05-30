{ pkgs, lib, ... }:
{
  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
    lxd.enable = true;
    libvirtd.enable = true;
  };

  programs.adb.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
  users.users.adham.extraGroups = [ "libvirtd" ];
}
