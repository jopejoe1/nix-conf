{
  modulesPath,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "cifs"
    "f2fs"
    "jfs"
    "ntfs"
    "reiserfs"
    "vfat"
    "xfs"
    "bchachefs"
  ];

  #hardware.raspberry-pi."4".fkms-3d.enable = true;

  jopejoe1 = {
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
  };

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  powerManagement.cpuFreqGovernor = "ondemand";
}
