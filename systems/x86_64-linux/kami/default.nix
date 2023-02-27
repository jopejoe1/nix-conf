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

  boot.supportedFilesystems = [ "ntfs" "zfs" "btrfs" ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  #boot.kernelParams = [ "module_blacklist=i915" ];

  environment.systemPackages = with pkgs; [
    git
  ];



  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    sysdig.enable = true;
    xwayland.enable = true;
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
}

