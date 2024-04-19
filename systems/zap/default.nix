{ config, pkgs, lib, modulesPath, ... }:

{
  jopejoe1 = {
    local.enable = true;
    nix.enable = true;
    zerotierone.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    ssh.enable = true;
    gui.enable = false;
  };

  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];

  networking.useDHCP = false;

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    };
  };

  services.nginx.virtualHosts = {
    "git.missing.ninja" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8085/";
      };
    };
    "doc.missing.ninja" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:3000/";
      };
    };
    "testing.missing.ninja"= {
      enableACME = true;
      forceSSL = true;
    };
    "db.missing.ninja" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://134.255.219.135:8000/";
      };
    };
  };

  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@missing.ninja";
  };

  services.jitsi-meet = {
    enable = false;
    hostName = "meet.missing.ninja";
    nginx.enable = true;
  };

  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;

  services.rss-bridge.enable = false;
  services.rss-bridge.virtualHost = "rss.missing.ninja";
  services.rss-bridge.whitelist = [ "*" ];

  services.forgejo = {
    enable = true;
    settings.server = {
      HTTP_PORT = 8085;
      ROOT_URL = "https://git.missing.ninja/";
    };
    lfs.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8000 ];
    allowedUDPPorts = [ 80 443 8000 ];
  };

  users.users.fp = {
    isNormalUser = true;
    initialPassword = "fp";
    description = "felix";
    openssh.authorizedKeys.keys = [
      "ssh.ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMBFp5TEsP0rdhkDpMfuMkCuLrDPoXBVu8EpRyLwuAMs fp@IAP-597"
      "ssh-ed25519 AAAAC3NzaC11ZDI1NTE5AAAAIMBFp5TEsPOrdhkDpMfuMkCuLrDP0XBVu8EpRyLWUAMs Fp@IAP-597"
    ];
  };

  time.timeZone = "Europe/Berlin";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  services.openssh.ports = [ 8081 22 ];

  services.hedgedoc = {
    enable = false;
    settings.domain = "doc.missing.ninja";
    settings.host = "localhost";
    settings.port = 3000;
    settings.protocolUseSSL = true;
  };
  services.surrealdb.enable = false;
  services.surrealdb.host = "134.255.219.135";

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

  services.wordpress = {
    webserver = "nginx";
    sites."testing.missing.ninja" = {
      languages = [ pkgs.wordpressPackages.languages.de_DE ];
      settings = {
        WPLANG = "de_DE";
      };
      virtualHost = {
        enableACME = true; 
      };
    };
  };
}
