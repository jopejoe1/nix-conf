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
    #nixos-hardware.nixosModules.common-gpu-intel
    #nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-ssd
    self.inputs.nether.nixosModules.hosts
    self.inputs.nether.nixosModules.zerotier
    self.inputs.srvos.nixosModules.desktop
  ];

  jopejoe1 = {
    audio = {
      enable = true;
      sennheiser-hd-660s = true;
    };
    bluetooth.enable = true;
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
    };
    boot.systemd.enable = true;
  };

  networking = {
    hostId = "16c22faf";
  };

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "intel";
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
    nvidia = {
      #package = config.boot.kernelPackages.nvidiaPackages.stable;
      #modesetting.enable = true;
    };
    gpgSmartcards.enable = true;
  };

  boot.kernelModules = [ "i2c-nct6775" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  environment.systemPackages = with pkgs; [
    localPkgs.prismlauncher-withExtraStuff
    picard
    mixxx
    goverlay
    (strawberry-qt6.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "1.1.0-rc3";
        src = fetchFromGitHub {
          owner = "strawberrymusicplayer";
          repo = "strawberry";
          rev = "1.1.0-rc3";
          hash = "sha256-4LhFxCi0ixMAjVaNVrQrLc0Vf1Z2dhnw6DTfTqtpiC4=";
        };
        buildInputs = previousAttrs.buildInputs ++ [
          kdsingleapplication
          gst_all_1.gst-plugins-rs
          kdePackages.qtsvg
          kdePackages.qtimageformats
        ];
      }
    ))
    libreoffice-qt
    jitsi-meet-electron
    thunderbird
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    droidcam.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
    appimage = {
      enable = true;
      package = pkgs.appimage-run.override { extraPkgs = pkgs: [ pkgs.brotli ]; };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libz
      xz
      xorg.libX11
      freetype
      zstd
      dbus
    ];
  };
}
