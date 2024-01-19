{ config, pkgs, lib, modulesPath, ... }:

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

  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];

  networking.useDHCP = false;

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    };
  };

  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;
  
  networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 80 ];
  allowedUDPPorts = [ 80 ];
};


#   networking = {
#     wireless.enable = lib.mkForce false;
#     interfaces.eth0 = {
#       ipv4.addresses = [{
#         address = "134.255.219.135";
#         prefixLength = 24;
#       }];
#     };
#     interfaces.ens18 = {
#       ipv4.addresses = [{
#         address = "185.249.199.92";
#         prefixLength = 24;
#       }];
#     };
#     defaultGateway = "134.255.219.1";
#   };

  time.timeZone = "Europe/Berlin";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  services.hedgedoc = {
    enable = true;
    settings.domain = "missing.ninja";
    settings.host = "missing.ninja";
    settings.port = 80;
  };
  services.surrealdb.enable = true;

  console = {
    enable = true;
  };
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
        type = "disk";
        content = {
          type = "table";
          format = "msdos";
          partitions = [
#             {
#               name = "ESP";
#               start = "1M";
#               end = "500M";
#               bootable = true;
#               content = {
#                 type = "filesystem";
#                 format = "vfat";
#                 mountpoint = "/boot";
#               };
#             }
            {
              name = "root";
              start = "500M";
              end = "100%";
              part-type = "primary";
              bootable = true;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
  };
}
