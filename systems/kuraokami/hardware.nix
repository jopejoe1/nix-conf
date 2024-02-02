# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.nvidia.prime = {
    offload.enable = false;
    sync.enable = false;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  zramSwap.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p2";
      fsType = "bcachefs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/1F26-8168";
      fsType = "vfat";
    };
    "/media/home" = {
      device = "/dev/disk/by-uuid/78d6db21-b823-4ca4-b495-7782d3e56ddc";
      fsType = "ext4";
    };
    "/media/gaming" = {
      device = "/dev/disk/by-uuid/4038F97238F966F6";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" ];
    };
    "/media/backup" = {
      device = "u384346@u384346.your-storagebox.de:/";
      fsType = "sshfs";
      options = [
        "_netdev"
        "allow_other"
        "x-systemd.automount"
        "IdentityFile=/home/jopejoe1/.ssh/github"
        "ServerAliveInterval=15"
        "reconnect"
      ];
    };
    #"/media/zfs" = {
    #   device = "jopejoe1";
    #   fsType = "zfs";
    #};
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}