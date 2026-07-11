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

  boot.initrd.network.udhcpc.enable = lib.mkForce false;

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      authorizedKeys = config.users.users.jopejoe1.openssh.authorizedKeys.keys;
    };
  };

  boot.initrd.systemd.network = {
    enable = true;
    networks."30-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "no";
      address = [
        "49.13.232.169/32"
        "2a01:4f8:c2c:3900::/64"
      ];
      dns = [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      routes = [
        {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        }
        {
          Gateway = "fe80::1";
        }
      ];
    };
  };

  systemd.network.networks."30-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "no";
    address = [
      "49.13.232.169/32"
      "2a01:4f8:c2c:3900::/64"
    ];
    dns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    routes = [
      {
        Gateway = "172.31.1.1";
        GatewayOnLink = true;
      }
      {
        Gateway = "fe80::1";
      }
    ];
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

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "20M";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
