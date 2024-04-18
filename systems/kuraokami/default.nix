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
    self.inputs.nether.nixosModules.hosts
    self.inputs.nether.nixosModules.zerotier
  ];

  jopejoe1 = {
    audio = {
      enable = true;
      sennheiser-hd-660s = true;
    };
    bluetooth.enable = true;
    doc.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma6.enable = true;
    printing.enable = true;
    steam.enable = true;
    ssh.enable = true;
    asf.enable = true;
    sway.enable = true;
    zerotierone.enable = true;
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
      enable = false;
      #extraPlugins = ps: with ps; [ pg_libversion ];
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
  };

  nixpkgs = {
    config = {
      cudaSupport = true;
      cudaCapabilities = [ "8.6" ];
    };
    hostPlatform = {
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
    gpgSmartcards.enable = true;
  };

  environment.systemPackages = with pkgs; [
    localPkgs.prismlauncher-withExtraStuff
    mixxx
    picard
    goverlay
    strawberry
    whatsapp-for-linux
    teams-for-linux
    libreoffice-qt
    webex
    jitsi-meet-electron

    ((discord.overrideAttrs (old: {
      desktopItem = old.desktopItem.override
        (old: { exec = old.exec + " --disable-gpu-sandbox"; });
    })).override {
      withOpenASAR = true;
      withVencord = true;
      withTTS = true;
    })
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
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.brotli ];
      };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  nix.settings.system-features = [ "gccarch-alderlake" "benchmark" "big-parallel" "kvm" "nixos-test" ]
    ++ map (x: "gccarch-${x}") (lib.systems.architectures.inferiors.alderlake or [ ]);

  boot.binfmt.emulatedSystems = [ "riscv64-linux" "aarch64-linux" ];
}
