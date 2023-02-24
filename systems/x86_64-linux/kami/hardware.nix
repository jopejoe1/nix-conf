{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-intel
    #common-gpu-nvidia
    common-pc
    common-pc-ssd
  ];

  hardware.nvidia.prime = {
    offload.enable = false;
    sync.enable = false;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_lts;

    initrd = {
      # kernelModules = [ "amdgpu" ];
      availableKernelModules =
        [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "sr_mod" ];
    };

    extraModulePackages = [ ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/99a47ace-7e69-4520-b914-d4fe5b31dc79";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/1F26-8168";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/78d6db21-b823-4ca4-b495-7782d3e56ddc";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # @NOTE(jakehamilton): NetworkManager will handle DHCP.
  networking.interfaces.enp6s0.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = false;

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.bluetooth.enable = true;
}
