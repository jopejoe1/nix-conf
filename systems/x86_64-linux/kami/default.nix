# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  networking.hostName = "kami";
  networking.hostId = "16c22faf";

  boot.supportedFilesystems = [ "ntfs" "btrfs" "zfs" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  #boot.kernelParams = [ "module_blacklist=i915" ];

  environment.systemPackages = with pkgs; [
    git
    prismlauncher
    libsForQt5.discover
    knossos
    skypeforlinux
    discord
    jetbrains.pycharm-professional
  ];

  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "intel";

  hardware.nvidia.modesetting.enable = true;
  hardware.steam-hardware.enable = true;

  services.flatpak.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.hsphfpd.enable = false; # Conflicts with wireplumber
  hardware.bluetooth.powerOnBoot = true;

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    sysdig.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  # Migrated Stuff
  custom.user.jopejoe1.enable =true;
  custom.user.root.enable =true;
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

  #custom.system.dns.enable = true;
}

