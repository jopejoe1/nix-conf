{ config, pkgs, lib, self, ... }:

{

  imports = [
    self.inputs.srvos.nixosModules.server
    self.inputs.srvos.nixosModules.hardware-hetzner-online-amd
    self.inputs.srvos.nixosModules.mixins-nginx
  ];

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
      device = config.fileSystems."/boot".device;
    };
  };

  systemd.network.networks."10-uplink".networkConfig.Address = " 2a01:4f8:a0:31e5::/64";

  time.timeZone = "Europe/Berlin";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  services.openssh.ports = [ 22 ];

  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };
          };
        };
      };
      vdc = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };
          };
        };
      };
    };
    mdadm = {
      raid0 = {
        type = "mdadm";
        level = 0;
        content = {
          type = "gpt";
          partitions = {
            primary = {
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
