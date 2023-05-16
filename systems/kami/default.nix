{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  services.ivpn.enable = true;

  networking.hostName = "kami";
  networking.hostId = "16c22faf";

  boot.supportedFilesystems = [ "ntfs" "btrfs" "zfs" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  #boot.kernelParams = [ "module_blacklist=i915" ];

  #services.boinc.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
    libsForQt5.discover
    skypeforlinux
    discord
    jetbrains.pycharm-professional
    carla
    tela-icon-theme
    #devolo-dlan-cockpit

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

  hardware.nvidia.modesetting.enable = true;

  services.flatpak.enable = true;

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    sysdig.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
  };
  console = {
    enable = true;
    keyMap = "de";
  };
  services.xserver = {
    layout = "de";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.systemd-boot.configurationLimit = 10;

  # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
  boot.loader.systemd-boot.editor = false;
}