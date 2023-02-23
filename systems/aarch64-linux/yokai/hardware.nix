{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware.nvidia.prime = {
    offload.enable = false;
    sync.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

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

  hardware.bluetooth.enable = true;
}
