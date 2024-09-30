{
  config,
  pkgs,
  lib,
  nixos-hardware,
  self,
  ...
}:

{
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-ssd
    self.inputs.nether.nixosModules.hosts
    self.inputs.nether.nixosModules.zerotier
    self.inputs.srvos.nixosModules.desktop
  ];

  facter.reportPath = ./facter.json;

  jopejoe1 = {
    audio = {
      enable = true;
      sennheiser-hd-660s = true;
    };
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    printing.enable = true;
    steam.enable = true;
    ssh.enable = true;
    asf.enable = true;
    sway.enable = true;
    zerotierone.enable = true;
    gui.enable = true;
    keyboard = {
      enable = true;
      layout = "de";
    };
    user = {
      jopejoe1.enable = true;
      root.enable = true;
      builder.enable = true;
    };
    boot.systemd.enable = true;
  };

  networking = {
    hostId = "16c22faf";
  };

  services = {
    hardware.openrgb = {
      enable = true;
    };
    postgresql = {
      enable = true;
      extraPlugins = ps: with ps; [ pg_libversion ];
      enableTCPIP = true;
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE DATABASE repology
        CREATE USER repology WITH PASSWORD 'repology'
        GRANT ALL ON DATABASE repology TO repology
      '';
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    nix-serve = {
      enable = false;
      openFirewall = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };

  nixpkgs = {
    config = {
      cudaSupport = false;
      cudaCapabilities = [ "8.6" ];
    };
    hostPlatform = {
      #  gcc.arch = "alderlake";
    };
  };

  time.timeZone = "Europe/Berlin";

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    gpgSmartcards.enable = true;
  };

  boot.kernelModules = [ "i2c-nct6775" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  environment.systemPackages = with pkgs; [
    prismlauncher
    picard
    mixxx
    goverlay
    strawberry-qt6
    jitsi-meet-electron
    thunderbird
    (ffmpeg-full.override {
      withTensorflow = true;
      withUnfree = true;
    })
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    droidcam.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
    tmux.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    alvr = {
      enable = true;
      openFirewall = true;
    };
  };

  nix.settings.system-features = [
    "gccarch-alderlake"
    "benchmark"
    "big-parallel"
    "kvm"
    "nixos-test"
  ] ++ map (x: "gccarch-${x}") (lib.systems.architectures.inferiors.alderlake or [ ]);

  boot.binfmt.emulatedSystems = [
    "riscv64-linux"
    "aarch64-linux"
  ];

  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "mauve";
  };
}
