# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" "armv6l-linux" "armv7l-linux" "aarch64_be-linux" "i386-linux" "i486-linux" "i586-linux" "alpha-linux" "sparc64-linux" "sparc-linux" "powerpc-linux" "powerpc64-linux" "powerpc64le-linux" "mips-linux" "mipsel-linux" "mips64-linux" "mips64el-linux" "riscv32-linux" "riscv64-linux" "wasm32-wasi" "wasm64-wasi" "x86_64-windows" "i686-windows" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  #boot.kernelParams = [ "module_blacklist=i915" ];

  services.boinc.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
    libsForQt5.discover
    skypeforlinux
    discord
    jetbrains.pycharm-professional
    python3
    python3Packages.numpy
    python3Packages.pandas
    python3Packages.requests
    python3Packages.json5
    python3Packages.pyperclip
    python3Packages.plotly
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

  # Migrated Stuff
  custom.user.jopejoe1.enable = true;
  custom.user.root.enable = true;
  custom.system.locale.enable = true;
  custom.system.locale.layout = "de";
  custom.nix.enable = true;
  custom.desktop.plasma.enable = true;
  custom.system.boot.uefi.enable = true;
  custom.system.xdg.enable = true;
  custom.system.fonts.enable = true;
  custom.hardware.audio.enable = true;
  custom.hardware.printing.enable = true;
  custom.system.ssh.enable = true;

  custom.hardware.rgb.enable = true;
  custom.hardware.rgb.motherboard = "intel";
  custom.hardware.bluetooth.enable = true;
  custom.programs.steam.enable = true;


  # Currently broken
  #custom.system.dns.enable = true;
}

