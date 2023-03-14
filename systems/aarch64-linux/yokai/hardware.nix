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


  swapDevices = [ ];


  # @NOTE(jakehamilton): NetworkManager will handle DHCP.
  networking.interfaces.wlan0.useDHCP = false;

  hardware.enableRedistributableFirmware = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
