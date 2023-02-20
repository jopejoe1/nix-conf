{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # Boot loader configutation
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };

    initrd = {
      availableKernelModules = [ "usbhid" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
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
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  networking = {
    hostName = "yokai";
    useDHCP = lib.mkDefault true;
    interfaces.wlan0.useDHCP = lib.mkDefault true;
  };

  services = {
    xserver = {
      # Configure keymap in X11
      layout = "us";
      # services.xserver.xkbOptions = {
      #   "eurosign:e";
      #   "caps:escape" # map caps to escape.
      # };

      # Enable touchpad support
      libinput.enable = true;
    };
  };

  console = {
    keyMap = "us";
  };

  time.timeZone = "Europe/Berlin";
}
