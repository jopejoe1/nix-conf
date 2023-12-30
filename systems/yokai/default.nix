{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  jopejoe1 = {
    audio = { enable = true; };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    printing.enable = true;
    jopejoe1.enable = true;
    root.enable = true;
  };

  networking = {
    hostName = "yokai";
    hostId = "af13bbec";
  };

  hardware.opengl.enable = true;

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    tela-icon-theme
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
      generic-extlinux-compatible.enable = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.editor = false;
    };
  };
}

