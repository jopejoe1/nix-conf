{ pkgs, ... }:

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
    jopejoe1.enable = true;
    nix.enable = true;
    root.enable = true;
  };

  networking = { hostName = "tuny"; };
  boot.loader.grub.device = "/dev/sda";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ mixxx ];

  time.timeZone = "Europe/Berlin";
}
