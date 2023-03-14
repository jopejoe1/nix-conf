{ pkgs, config, lib, channel, ... }:

with lib;
#with lib.internal;
{
  imports = [ ./hardware.nix ];

  networking.networkmanager.enable = true;
  networking.hostName = "yokai";

  time.timeZone = "Europe/Berlin";
  hardware.opengl.enable = true;

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    xwayland.enable = true;
  };

  # System
  custom.system.boot.uboot.enable = true;
  custom.system.xdg.enable = true;
  custom.system.fonts.enable = true;
  custom.system.locale.enable = true;
  custom.system.locale.layout = "us";
  custom.system.ssh.enable = true;
  custom.nix.enable = true;
  custom.hardware.audio.enable = true;
  custom.hardware.printing.enable = true;
  custom.desktop.plasma.enable = true;
  custom.hardware.bluetooth.enable = true;

  # User
  custom.user.jopejoe1.enable = true;
  custom.user.root.enable = true;
}
