{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  network_interface_name =
    (lib.elemAt config.facter.report.hardware.network_interface 0).unix_device_name;
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

  boot.initrd.systemd.enable = true;

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
    dhcpcd.enable = true;
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
    useDHCP = true;
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
    nginx = {
      enableACME = true;
      forceSSL = true;
    };
    config = {
      ":pleroma" = {
        ":instance" = {
          name = "Nyan Social";
          description = "A Nyantastic Fediverse instance!";
          email = "admin@nyan.social";
          registrations_open = false;
          account_activation_required = true;
          account_approval_required = true;
          external_user_synchronization = true;
          show_reactions = true;
          invites_enabled = true;
          federating = true;
          federation_incoming_replies_max_depth = null;
          max_remote_account_fields = 100;
          federated_timeline_available = true;
          languages = [
            "en"
            "de"
          ];
          local_bubble = [
            "social.nekover.se"
          ];
        };
        ":mrf_steal_emoji" = {
          hosts = [
            "social.nekover.se"
          ];
          download_unknown_size = true;
        };
        "Pleroma.Web.Endpoint" = {
          url.host = "nyan.social";
        };
        "Pleroma.Upload".base_url = "https://nyan.social/media/";
      };
    };
  };

  services.woodpecker-server = {
    enable = true;
    environment = {
      WOODPECKER_HOST = "https://ci.missing.ninja";
      WOODPECKER_OPEN = "true";
      WOODPECKER_FORGEJO = "true";
      WOODPECKER_ADMIN = "irgendwas";
      WOODPECKER_FORGEJO_URL = "https://git.missing.ninja";
      WOODPECKER_FORGEJO_CLIENT = "";
      WOODPECKER_FORGEJO_SECRET = "";
      WOODPECKER_AGENT_SECRET = "";
    };
  };

  services.woodpecker-agents.agents = {
    hetzner = {
      enable = true;
      environment = {
        WOODPECKER_SERVER = "localhost:9000";
        WOODPECKER_MAX_WORKFLOWS = "8";
        WOODPECKER_AGENT_SECRET = "";
        WOODPECKER_BACKEND = "docker";
        DOCKER_HOST = "unix:///run/podman/podman.sock";
      };
      extraGroups = [ "podman" ];
    };
  };

  virtualisation.podman.defaultNetwork.settings.dns_enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  networking.firewall.interfaces."podman+" = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };

  users.users.backupftp = {
    isNormalUser = true;
    initialPassword = "backupPassword";
  };

  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.missing.ninja";
    notificationSender = "hydra@missing.ninja";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
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
