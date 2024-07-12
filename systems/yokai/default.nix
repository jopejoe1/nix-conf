{
  config,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.pine64-pinebook-pro
  ];

  jopejoe1 = {
    audio.enable = true;
    local.enable = true;
    nix.enable = true;
    sway.enable = true;
    gui.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
  };

  networking = {
    hostId = "af13bbec";
  };

  hardware.graphics.enable = true;

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
    xwayland.enable = true;
    kdeconnect.enable = true;
  };
  console = {
    enable = true;
    keyMap = "us";
  };
  services.xserver = {
    xkb.layout = "us";
  };

  boot = {
    supportedFilesystems = [
      "ntfs"
      "btrfs"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };
}
