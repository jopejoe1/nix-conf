{
  config,
  pkgs,
  lib,
  self,
  ...
}:

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

  #hardware.facter.reportPath = ./facter.json;
  hardware.facter.detected.dhcp.enable = false;

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
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.Name = "en*";
    address = [
      "85.10.200.204/27"
    ];
    gateway = [
      "fe80::1"
      "85.10.200.193"
    ];
    dns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    networkConfig = lib.mkForce {
      Address = "2a01:4f8:a0:31e5::/64";
      DHCP = false;
      IPv6AcceptRA = "no";
    };
  };

  boot.initrd.network.udhcpc.enable = lib.mkForce false;

  time.timeZone = "Europe/Berlin";

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  services.openssh.ports = [ 22 ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@missing.ninja";

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
    enable = false;
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
      enable = false;
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

  services.hydra = {
    enable = false;
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
