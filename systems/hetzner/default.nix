{ config, pkgs, lib, ... }:

{
  jopejoe1 = {
    local.enable = true;
    nix.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
  };

  boot.initrd.availableKernelModules = [ "ahci" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NX0RA55622";
    };
  };


  networking.usePredictableInterfaceNames = false;
  networking.dhcpcd.enable = false;
  systemd.network = {
    enable = true;
    networks."eth0" = {
      extraConfig = ''
        [Match]
        Name = eth0
        [Network]
        # Add your own assigned ipv6 subnet here here!
        Address = 2a01:4f8:a0:31e5::/64
        Gateway = fe80::1
        # optionally you can do the same for ipv4 and disable DHCP (networking.dhcpcd.enable = false;)
        Address = 85.10.200.204
        Gateway = 85.10.200.193
      '';
    };
  };

  time.timeZone = "Europe/Berlin";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  console = {
    enable = true;
  };
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NX0RA55622";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
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
      two = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NX0RA55649";
        content = {
          type = "gpt";
          partitions = {
            extra = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/media/extra";
              };
            };
          };
        };
      };
    };
  };
}
