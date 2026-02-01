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
#    self.inputs.nether.nixosModules.hosts
#    self.inputs.nether.nixosModules.zerotier
    self.inputs.srvos.nixosModules.desktop
  ];

  hardware.facter.reportPath = ./facter.json;

  nixpkgs.overlays = [ self.inputs.niri.overlays.niri ];

  networking.networkmanager = {
    enable = true;
    settings = {
      keyfile = {
        path = "/var/lib/NetworkManager-system-connections/";
      };
    };
  };

  jopejoe1 = {
    audio = {
      enable = true;
      sennheiser-hd-660s = true;
    };
    local.enable = true;
    nix.enable = true;
    plasma.enable = false;
    printing.enable = true;
    steam.enable = true;
    ssh.enable = true;
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
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };
  };

  boot.initrd.systemd.enable = true;

  services = {
    hardware.openrgb = {
      enable = true;
    };
    zerotierone.joinNetworks = [
      "d5e5fb653774ee43"
    ];
    postgresql = {
      enable = true;
      extensions = ps: with ps; [ pg_libversion ];
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

  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
  ];

  home-manager.users.jopejoe1 = {
    programs.alacritty.enable = true;
    programs.fuzzel.enable = true;
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
    programs.swaylock.enable = true;
    programs.niri.settings = {
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite-unstable;
      };
      binds = with config.home-manager.users.jopejoe1.lib.niri.actions; {
        "Super+D".action.spawn = "fuzzel";
        "Super+Shift+E".action = quit;
        "Super+Q".action = close-window;
        "Super+T".action.spawn = "alacritty";
        "Super+Alt+L".action.spawn = "swaylock";
        "Super+Equal".action = set-column-width "+10%";
        "Super+Minus".action = set-column-width "-10%";
        "Super+H".action = focus-column-left;
        "Super+L".action = focus-column-right;
        "Super+K".action = focus-window-up;
        "Super+J".action = focus-window-down;
        "Super+I".action = focus-workspace-up;
        "Super+U".action = focus-workspace-down;
        "Super+Shift+H".action = focus-monitor-left;
        "Super+Shift+L".action = focus-monitor-right;
        "Super+Shift+K".action = focus-monitor-up;
        "Super+Shift+J".action = focus-monitor-down;
        "Super+Shift+I".action = move-workspace-up;
        "Super+Shift+U".action = move-workspace-down;
      };
      input.keyboard.xkb = {
        inherit (config.services.xserver.xkb)
          variant
          options
          model
          layout
          ;
      };
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
    #mixxx
    goverlay
    vkbasalt
    vkbasalt-cli
    mangohud
    mangojuice
    strawberry
    thunderbird
    gh
    (ffmpeg-full.override {
      #withTensorflow = true;
      withUnfree = true;
    })
    vulkan-hdr-layer-kwin6
  ];

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
    tmux.enable = true;
    niri.enable = true;
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
  ]
  ++ map (x: "gccarch-${x}") (lib.systems.architectures.inferiors.alderlake or [ ]);

  boot.binfmt.emulatedSystems = [
    "riscv64-linux"
    "aarch64-linux"
  ];
}
