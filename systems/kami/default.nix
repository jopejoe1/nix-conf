{ config, pkgs, lib, nixos-hardware, self, ... }:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-intel
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  jopejoe1 = {
    audio = {
      enable = true;
      sennheiser-hd-660s = true;
    };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma6.enable = true;
    printing.enable = true;
    steam.enable = true;
    ssh.enable = true;
    asf.enable = true;
    sway.enable = true;
    minecraft-server.enable = true;
    repo-sync.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    boot.systemd.enable = true;
  };

  networking = {
    hostName = "kami";
    hostId = "16c22faf";
  };

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "intel";
    };
    fwupd.enable = true;
    xserver = {
      videoDrivers = [ "nvidia" ];
      layout = "de";
    };
  };

  nixpkgs = {
    config = {
      cudaSupport = true;
      cudaCapabilities = [ "8.6" ];
    };
    hostPlatform = {
      system = "x86_64-linux";
      config = "x86_64-unknown-linux-gnu";
      #  gcc.arch = "alderlake";
    };
  };

  time.timeZone = "Europe/Berlin";

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    localPkgs.prismlauncher-withExtraStuff
    mixxx
    picard
    mangohud
    goverlay
    strawberry
    whatsapp-for-linux
    teams-for-linux
    webex
    discord
    element-desktop
    mumble

    # Theming
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    localPkgs.tela-icon-theme-git
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    droidcam.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
  };
  console = {
    enable = true;
    keyMap = "de";
  };

  nix.settings.system-features = [ "gccarch-alderlake" "benchmark" "big-parallel" "kvm" "nixos-test" ];
}
