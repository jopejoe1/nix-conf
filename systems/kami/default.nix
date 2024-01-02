{ config, pkgs, lib, nixos-hardware, ... }:

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
    overlays.enable = true;
    steam.enable = true;
    asf.enable = true;
    minecraft-server.enable = true;
    repo-sync.enable = true;
    jopejoe1.enable = true;
    root.enable = true;
  };

  networking = {
    hostName = "kami";
    hostId = "16c22faf";
  };

  services = {
    hardware.openrgb.enable = true;
    fwupd.enable = true;
    xserver = {
      videoDrivers = [ "nvidia" ];
      layout = "de";
    };
  };

  nixpkgs = {
    config = { cudaSupport = true; };
    hostPlatform = {
      system = "x86_64-linux";
      config = "x86_64-unknown-linux-gnu";
      #  gcc.arch = "alderlake";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_testing;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
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
    prismlauncher
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
    tela-icon-theme
  ];

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    sysdig.enable = false;
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

  nix.settings.system-features =
    [ "gccarch-alderlake" "benchmark" "big-parallel" "kvm" "nixos-test" ];
  systemd.services.nix-daemon.serviceConfig.LimitNOFILE =
    lib.mkForce 1048576000;
}
