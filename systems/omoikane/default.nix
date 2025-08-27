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
    self.inputs.srvos.nixosModules.desktop
  ];

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

  jopejoe1 = {
    audio = {
      enable = true;
    };
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    printing.enable = true;
    steam.enable = true;
    ssh.enable = true;
    sway.enable = true;
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
    #repology.enable = true;
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

  services.suwayomi-server.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
    thunderbird
    strawberry
    picard
    gh
    kdePackages.wallpaper-engine-plugin
    nix-output-monitor
    gns3-gui
    libreoffice-qt6-fresh
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    gamemode.enable = true;
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
