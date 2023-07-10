{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  networking.hostName = "yokai";
  networking.hostId = "af13bbec";

  boot.supportedFilesystems = [ "ntfs" "btrfs" "zfs" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  hardware.opengl.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    git

    # Theming
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    tela-icon-theme

    # Fonts
    google-fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji-blob-bin
    nerdfonts
    league-of-moveable-type
    twitter-color-emoji
  ];

  services.flatpak.enable = true;

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
  services.xserver = {
    layout = "us";
  };

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
    systemd-boot.configurationLimit = 10;
    systemd-boot.editor = false;
  };
}

