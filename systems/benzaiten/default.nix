{ pkgs, config, nixos-hardware, ... }:

{
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-intel
    #nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-hdd
  ];

  jopejoe1 = {
    audio = { enable = true; };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    printing.enable = true;
    ssh.enable = true;
    keyboard = {
      enable = true;
      layout = "de";
    };
    gui.enable = true;
    zerotierone.enable = true;
  };

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:01:00:0";
    intelBusId = "PCI:00:02:0";
  };

  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  networking.nat.enable = true;

  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enable = true;

  environment.systemPackages = with pkgs; [ mixxx ];

  time.timeZone = "Europe/Berlin";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.suwayomi-server = {
    enable = true;
    settings = {
      server = {
        systemTrayEnabled = true;
        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        ];
        webUIEnabled = true;
        initialOpenInBrowserEnabled = true;
        webUIInterface = "browser";
        webUIFlavor = "WebUI";
      };
    };
  };

  services.freshrss = {
    enable = true;
    virtualHost = "rss.local";
    authType = "none";
    baseUrl = "http://rss.local";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "manga.local" = {
        locations."/" = {
          proxyPass = "http://localhost:8080/";
        };
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    ipv6 = true;
  };

  services.ivpn.enable = true;

  programs.kclock.enable = true;

  networking.hosts = {
    "192.168.88.251" = [ "wiki.it3" ];
    "192.168.88.252" = [ "pi400" ];
    "127.0.0.1" = [ "local" "rss.local" "manga.local" ];
  };
}
