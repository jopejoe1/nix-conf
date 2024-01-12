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
    overlays.enable = true;
    nix.enable = true;
    plasma.enable = true;
    jopejoe1.enable = true;
    root.enable = true;
    ssh.enable = true;
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
    element-desktop
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

  nixpkgs.hostPlatform = {
    system = "aarch64-linux";
    config = "aarch64-unknown-linux-gnu";
  };

  boot = {
    supportedFilesystems = [ "ntfs" "btrfs" "zfs" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };
}

