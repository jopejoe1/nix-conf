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
    ./disk.nix
    #nixos-hardware.nixosModules.framework-16-7040-amd
    self.inputs.srvos.nixosModules.desktop
  ];

  facter.reportPath = ./facter.json;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libcxx
      SDL
      openal
      libcaca
      xorg.libXext
      xorg.libX11
      libpulseaudio
      alsa-lib
    ];
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
    gui.enable = true;
    keyboard = {
      enable = true;
      layout = "us";
    };
    neovim.enable = true;
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

  environment.systemPackages = with pkgs; [
    prismlauncher
    thunderbird
    strawberry-qt6
    picard
    gh
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

  boot.binfmt.emulatedSystems = [
    "riscv64-linux"
    "aarch64-linux"
    "armv6l-linux"
  ];

  boot.initrd.systemd.enable = true;
  programs.captive-browser = {
    enable = true;
    interface = "wlp5s0";
  };
}
