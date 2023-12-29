{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  jopejoe1 = {
    audio = {
      enable = true;
    };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma6.enable = true;
    printing.enable = true;
    steam.enable = true;
    asf.enable = true;
    minecraft-server.enable = true;
    repo-sync.enable = true;
    jopejoe1.enable = true;
    root.enable = true;
  };

  networking.hostName = "kami";
  networking.hostId = "16c22faf";
  services.hardware.openrgb.enable = true;
  services.fwupd.enable = true;

  nixpkgs.config = {
    cudaSupport = true;
    allowAliases = false;
    allowUnfree = true;
  };

  services.xserver.desktopManager.kodi.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelPackages = pkgs.linuxPackages_testing;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  services.logmein-hamachi.enable = true;
  programs.haguichi.enable = true;

  #boot.kernelParams = [ "module_blacklist=i915" ];

  fonts.packages = with pkgs; [
    google-fonts
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji-blob-bin
    nerdfonts
    league-of-moveable-type
    twitter-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    mcrcon
    prismlauncher
    libsForQt5.discover
    skypeforlinux
    jetbrains.pycharm-community
    jetbrains.idea-community
    carla
    #devolo-dlan-cockpit
    libsForQt5.qtstyleplugin-kvantum
    mixxx
    picard
    mangohud
    goverlay
    strawberry
    whatsapp-for-linux
    qdirstat
    teams-for-linux
    webex
    discord
    element-desktop
    mumble

    (python3.withPackages(ps: with ps; [ beautifulsoup4 requests]))

    # Theming
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    tela-icon-theme
  ];

  programs.java = {
    enable = true;
    binfmt = true;
  };

  hardware.nvidia.modesetting.enable = true;

  services.flatpak.enable = true;

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    #sysdig.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
  };
  console = {
    enable = true;
    keyMap = "de";
  };
  services.xserver = {
    layout = "de";
  };

  #boot.plymouth = {
   # enable = true;
    #themePackages = [ pkgs.catppuccin-plymouth ];
    #theme = "catppuccin-frappe";
 # };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.systemd-boot.configurationLimit = 10;

  # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
  boot.loader.systemd-boot.editor = false;

  # Re-Compile everything for my specific cpu
  nix.settings.system-features = ["gccarch-alderlake" "benchmark" "big-parallel" "kvm" "nixos-test"];
  systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576000;
  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
    config = "x86_64-unknown-linux-gnu";
  #  gcc.arch = "alderlake";
  };
}
