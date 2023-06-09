{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-amd
    common-gpu-amd
    common-pc
    #common-pc-ssd
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    initrd = {
      # kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "sr_mod" ];
    };

    extraModulePackages = [ ];
  };

    fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c013c58e-540f-4547-b218-f7d34b07f7df";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/F1C3-4668";
      fsType = "vfat";
    };
  };

  swapDevices = [ {
    device = "/dev/disk/by-uuid/8a721407-d8bc-4d2d-970a-7ff462107dc3";
  } ];


  # @NOTE(jakehamilton): NetworkManager will handle DHCP.
  networking.interfaces.enp2s0.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = false;

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
