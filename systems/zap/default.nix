{
  pkgs,
  lib,
  modulesPath,
  srvos,
  ...
}:

{
  jopejoe1 = {
    local.enable = true;
    nix.enable = true;
    zerotierone.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
      builder.enable = true;
    };
    ssh.enable = true;
    gui.enable = false;
  };

  hardware.facter.reportPath = ./facter.json;
  hardware.facter.detected.dhcp.enable = false;

  boot.initrd.systemd.enable = true;

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    srvos.nixosModules.server
    srvos.nixosModules.mixins-nginx
    ./wp-test.nix
  ];

  networking.useDHCP = false;

  systemd.network.networks."10-uplink" = {
    address = [
      "134.255.219.135/24"
    ];
    gateway = [
      "134.255.219.1"
    ];
    dns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    matchConfig = {
      Name = "eth0";
    };
    networkConfig = lib.mkForce {
      DHCP = false;
      IPv6AcceptRA = "no";
    };
  };

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
    #"db.missing.ninja" = {
    #  enableACME = true;
    #  forceSSL = true;
    #   locations."/" = {
    #    proxyPass = "http://134.255.219.135:8000/";
    #   };
    # };
  };

  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@missing.ninja";
  };

  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    settings = {
      server = {
        HTTP_PORT = 8085;
        ROOT_URL = "https://git.missing.ninja/";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
    lfs.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      8000
    ];
    allowedUDPPorts = [
      80
      443
      8000
    ];
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

  services.openssh.ports = [
    8081
    22
  ];

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
}
