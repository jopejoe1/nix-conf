{ pkgs, config, lib, channel, ... }:

with lib;
#with lib.internal;
{
  networking.networkmanager.enable = true;

  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
    parted
    gnufdisk
    partition-manager
  ];

  hardware.enableRedistributableFirmware = true;

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  # System
  custom.system.boot.uboot.enable = true;
  custom.system.ssh.enable = true;
  custom.nix.enable = true;
  custom.hardware.audio.enable = true;
  custom.desktop.plasma.enable = true;

  # User
  custom.user.jopejoe1.enable = true;
  custom.user.root.enable = true;
}
