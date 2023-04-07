{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    initrd = {
      # kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "usbhid" ];
    };

    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };


  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = (4*1024)+(2*1024);
  } ];

  hardware.enableRedistributableFirmware = true;
}
