{ config, pkgs, lib, modulesPath, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelModules = [ "kvm-amd" ];
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

  networking.hostName = "oni";

  time.timeZone = "Europe/Berlin";

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  console.keyMap = "de";

  networking = {
    useDHCP = lib.mkDefault true;
    interfaces = {
      enp2s0.useDHCP = lib.mkDefault true;
      wlp3s0.useDHCP = lib.mkDefault true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
}
