{ modulesPath, lib, nixos-hardware, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = { availableKernelModules = [ "xhci_pci" ]; };
    loader = { generic-extlinux-compatible.enable = true; };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  hardware.raspberry-pi."4".fkms-3d.enable = true;

  jopejoe1 = {
    audio.enable = true;
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    root.enable = true;
  };

  networking = {
    hostName = "inugami";
    useDHCP = lib.mkDefault true;
  };

  nixpkgs.hostPlatform = {
    system = "aarch64-linux";
    config = "aarch64-unknown-linux-gnu";
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
