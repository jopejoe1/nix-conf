{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  network_interface_name = (lib.elemAt config.facter.report.hardware.network_interface 0).unix_device_name;
in
{

  imports = [
    self.inputs.srvos.nixosModules.server
    self.inputs.srvos.nixosModules.hardware-hetzner-online-amd
    self.inputs.srvos.nixosModules.mixins-nginx
    self.inputs.snm.nixosModules.mailserver
    ./mail.nix
    ./matrix.nix
    ./nginx.nix
    ./radicale.nix
  ];

  facter.reportPath = ./facter.json;

  jopejoe1 = {
    local.enable = true;
    nix.enable = true;
    zerotierone.enable = true;
    asf.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
      builder.enable = true;
    };
    ssh.enable = true;
  };

  boot.loader = {
    grub = {
      enable = true;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        21
        80
      ];
      allowedUDPPorts = [
        21
        80
      ];
    };
    bridges.br0.interfaces = [
      network_interface_name
    ];
    useDHCP = false;
    interfaces."br0" = {
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.100.3";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.100.1";
      interface = network_interface_name;
    };
    nameservers = [ "192.168.100.1" ];
  };

  systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f8:a0:31e5::/64";

  time.timeZone = "Europe/Berlin";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  services.openssh.ports = [ 22 ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@missing.ninja";

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    userlistEnable = true;
    userlist = [ "backupftp" ];
    localUsers = true;
    chrootlocalUser = true;
  };

  services.akkoma = {
    enable = true;
    package = pkgs.akkoma.overrideAttrs (finalAttrs: previousAttrs: {
      src = pkgs.fetchFromGitea {
        domain = "akkoma.dev";
        owner = "AkkomaGang";
        repo = "akkoma";
        rev = "92e9ca0fafc94b84c618647d646efa11d29d9cfc";
        hash = "sha256-Bi+ooGMxbPIZErTILckgwYcgmN8LMlX43MF39x+KKvs=";
      };
    });
    nginx = {
      enableACME = true;
      forceSSL = true;
    };
    config = {
      ":pleroma" = {
        ":instance" = {
          name = "Nyan Social";
          description = "More detailed description";
          email = "admin@nyan.social";
          registration_open = false;
        };
        "Pleroma.Web.Endpoint" = {
          url.host = "nyan.social";
        };
        "Pleroma.Upload".base_url = "https://nyan.social/media/";
      };
    };
  };

  users.users.backupftp = {
    isNormalUser = true;
    initialPassword = "backupPassword";
  };

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
