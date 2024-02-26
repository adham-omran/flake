# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "thunderbolt" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f53269ca-51a4-455b-819b-93905ff5db20";
      fsType = "ext4";
    };

  fileSystems."/data" = {
  device = "/dev/disk/by-uuid/be658d8a-1f06-48a8-9d22-77dee9edf303";
  fsType = "ext4";
};

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EBA1-C026";
      fsType = "vfat";
    };


  fileSystems."/mnt/pool" = {
    device = "truenas:/mnt/pool";
    fsType = "nfs";
  };


  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp74s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp73s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
