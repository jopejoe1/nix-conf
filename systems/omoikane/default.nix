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
    ./disk.nix
    #nixos-hardware.nixosModules.framework-16-7040-amd
  ];

  nixpkgs.overlays = [ self.inputs.niri.overlays.niri ];

  facter.reportPath = ./facter.json;

  virtualisation.xen = {
    enable = false;
    efi.bootBuilderVerbosity = "info"; # Adds a handy report that lets you know which Xen boot entries were created.
    bootParams = [
      "vga=ask" # Useful for non-headless systems with screens bigger than 640x480.
      "dom0=pvh" # Uses the PVH virtualisation mode for the Domain 0, instead of PV.
    ];
    dom0Resources = {
      memory = 32768; # Only allocates 1GiB of memory to the Domain 0, with the rest of the system memory being freely available to other domains.
      maxVCPUs = 8; # Allows the Domain 0 to use, at most, two CPU cores.
    };
  };

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
    };
    local.enable = true;
    nix.enable = true;
    plasma.enable = false;
    printing.enable = true;
    steam.enable = true;
    ssh.enable = true;
    sway.enable = false;
    zerotierone.enable = true;
    doc.enable = true;
    gui.enable = true;
    keyboard = {
      enable = true;
      layout = "us";
    };
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    boot.systemd.enable = true;
  };

  services.xserver = {
    xkb.variant = "altgr-intl";
  };

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    fwupd.enable = true;
    libinput.enable = true;
    zerotierone.joinNetworks = [
      "d5e5fb653774ee43"
    ];
  };

  time.timeZone = "Europe/Berlin";

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    gpgSmartcards.enable = true;
  };

  environment.systemPackages = with pkgs; [
    prismlauncher
    thunderbird
    strawberry
    picard
    gh
    nix-output-monitor
    jetbrains.webstorm
    neovim
  ];

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

  programs = {
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  nix.settings.system-features = [
    "benchmark"
    "big-parallel"
    "kvm"
    "nixos-test"
  ];

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

  boot.initrd.systemd.enable = true;
  programs.captive-browser = {
    enable = true;
    interface = "wlp5s0";
  };

  fileSystems = {
    "/home/jopejoe1/Public/games" = {
      device = "/dev/disk/by-label/gaming";
      fsType = "bcachefs";
      options = [
        "compression=zstd"
        "nofail"
      ];
    };
    "/home/jopejoe1/Music" = {
      device = "/dev/disk/by-label/music";
      fsType = "ext4";
      options = [
        "nofail"
      ];
    };
  };

  zramSwap = {
    enable = true;
    writebackDevice = "/dev/disk/by-partlabel/zram-writeback";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
