{ pkgs, config, ... }:

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

  boot = {
    # Boot loader configutation
    loader = {
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    generic-extlinux-compatible.enable = true;
    systemd-boot.configurationLimit = 10;
  };
}
