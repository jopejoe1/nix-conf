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

  hardware.raspberry-pi."4".fkms-3d.enable = true;

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

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  networking = {
    useDHCP = lib.mkDefault true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
