{ pkgs, config, nixos-hardware, ... }:

{
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-hdd
  ];

  jopejoe1 = {
    audio = { enable = true; };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
    keyboard = {
      enable = true;
      layout = "de";
    };
  };

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:01:00:0";
    intelBusId = "PCI:00:02:0";
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enable = true;

  environment.systemPackages = with pkgs; [ mixxx ];

  time.timeZone = "Europe/Berlin";
}
