{ config, lib, pkgs, self, ... }:

let cfg = config.jopejoe1.nix;
in {
  options.jopejoe1.nix = { enable = lib.mkEnableOption "Enable Nix"; };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        substituters = lib.mkForce [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "http://kuraokami:5000"
        ];
        trusted-public-keys = lib.mkForce [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "kuraokami:2H7ZvTtwBccxDW7QGzhiQk81ey7iVSjsjqVv4gn+zog="
        ];
        trusted-users = [ "root" ];
        sandbox = true;
        require-sigs = true;
        max-jobs = "auto";
        auto-optimise-store = true;
        allowed-users = [ "*" ];
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = true;
        use-xdg-base-directories = true;
        keep-going = true;
        builders-use-substitutes = true;
      };
      buildMachines = [
        (rec {
          systems = [ self.nixosConfigurations.kuraokami.config.nixpkgs.hostPlatform.system ];
          supportedFeatures = self.nixosConfigurations.kuraokami.config.nix.settings.system-features;
          maxJobs = if hostName != config.networking.hostName then 24 else 0;
          speedFactor = 20;
          sshKey = "/home/jopejoe1/.ssh/github";
          sshUser = "jopejoe1";
          hostName = "kuraokami";
          protocol = "ssh-ng";
        })
        {
          systems = [ self.nixosConfigurations.zap.config.nixpkgs.hostPlatform.system ];
          supportedFeatures = self.nixosConfigurations.zap.config.nix.settings.system-features;
          maxJobs = if hostName != config.networking.hostName then 4 else 0;;
          speedFactor = 10;
          sshUser = "jopejoe1";
          sshKey = "/home/jopejoe1/.ssh/github";
          hostName = "zap";
          protocol = "ssh-ng";
        }
      ];
      distributedBuilds = true;
      package = pkgs.nixVersions.unstable;
      registry = lib.mkForce ((lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) self.inputs) // {
        self.flake = self;
      });
      nixPath = lib.mkForce [ "/etc/nix/path" ];

    };

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        (_self: super: rec {
          firefox-addons = self.inputs.firefox-addons.packages.${config.nixpkgs.hostPlatform.system};
          localPkgs = self.outputs.packages.${config.nixpkgs.hostPlatform.system};
        })
      ];
    };

    services.nix-serve = {
      enable = true;
      openFirewall = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };


    environment.etc = lib.mapAttrs' (name: value: { name = "nix/path/${name}"; value.source = value.flake; }) config.nix.registry;

    environment.systemPackages = with pkgs; [
      deploy-rs
      nixfmt
      nixpkgs-fmt
      nix-index
      nix-prefetch-git
      nixpkgs-review
      nurl
      nix-init
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        self.outputs.homeManagerModules.default
      ];
    };

    systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576000;

    networking.extraHosts = ''
      192.168.191.46 zap
      192.168.191.142 kuraokami
    '';
  };
}

