{
  config,
  lib,
  pkgs,
  ...
}:

{
  jopejoe1 = {
    ssh.enable = true;
    nix.enable = true;
    #zerotierone.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "console=tty" ];
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  networking.useNetworkd = true;
  networking.useDHCP = false;
  services.qemuGuest.enable = lib.mkDefault true;
  systemd.services.qemu-guest-agent.path = [ pkgs.shadow ];
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings.ssh_deletekeys = lib.mkDefault false;
  };
  
  services.immich = {
    enable = true;
    host = "photos.joens.family";
  };

  services.nginx = {
    enable = true;
    virtualHosts."${config.services.immich.host}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@joens.family";
  };

  nixpkgs.hostPlatform = { system = "aarch64-linux"; };

  time.timeZone = "Europe/Berlin";

  fileSystems."/" = lib.mkDefault {
    device = "/dev/sda3";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/sda2";
    fsType = "vfat";
  };

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

}
