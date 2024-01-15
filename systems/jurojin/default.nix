{ config, pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.pine64-pinebook-pro
  ];

  jopejoe1 = {
    audio = { enable = true; };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    sway.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
  };

  networking = {
    hostId = "af13bbec";
  };

  hardware.opengl.enable = true;

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    tela-icon-theme
    element-desktop
    kitty
  ];

  programs = {
    droidcam.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
  };
  console = {
    enable = true;
    keyMap = "us";
  };
  services.xserver = { layout = "us"; };

  boot = {
    supportedFilesystems = [ "ntfs" "btrfs" "zfs" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };
}

