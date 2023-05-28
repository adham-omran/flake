{ pkgs, lib, ... }:
{
  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
  users.users.adham.extraGroups = [ "libvirtd" ];
}
