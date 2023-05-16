{ pkgs, config, lib, channel, ... }:

with lib;
#with lib.internal;
{
  imports = [ ./hardware.nix ];

  networking.networkmanager.enable = true;
  networking.hostName = "oni";
  time.timeZone = "Europe/Berlin";
  hardware.opengl.enable = true;

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    sysdig.enable = true;
    xwayland.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.systemd-boot.configurationLimit = 10;

  # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
  boot.loader.systemd-boot.editor = false;
}
