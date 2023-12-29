{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware.nix
    ];

  jopejoe1 = {
    audio = {
      enable = true;
    };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    printing.enable = true;
    jopejoe1.enable = true;
    root.enable = true;
  };

  networking.hostName = "yokai";
  networking.hostId = "af13bbec";

  boot.supportedFilesystems = [ "ntfs" "btrfs" "zfs" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  hardware.opengl.enable = true;

  networking.networkmanager.enable = true;

  networking.networkmanager.ensureProfiles.profiles = {
    "37C3" = {
      connection = {
        id = "37C3";
        type = "wifi";
        interface-name = "wlan0";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "37C3";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        anonymous-identity = "37C3";
        eap = "ttls;";
        identity = "37C3";
        password = "37C3";
        phase2-auth = "mschapv2";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
  };


  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    git

    # Theming
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    tela-icon-theme

    # Fonts
    #google-fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji-blob-bin
    #nerdfonts
    #league-of-moveable-type
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

