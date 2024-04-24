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
    kodi.enable = true;
    plasma.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
