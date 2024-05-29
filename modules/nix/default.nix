{ config, lib, pkgs, self, ... }:

let cfg = config.jopejoe1.nix;
in {
  options.jopejoe1.nix = { enable = lib.mkEnableOption "Enable Nix"; };
  options.jopejoe1.gui = { enable = lib.mkEnableOption "Enable GUI"; };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        substituters = lib.mkForce [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = lib.mkForce [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = [ "root" ];
        sandbox = true;
        require-sigs = true;
        max-jobs = "auto";
        auto-optimise-store = true;
        allowed-users = [ "*" ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = true;
        use-xdg-base-directories = true;
        keep-going = true;
        builders-use-substitutes = true;
      };
#       buildMachines = [
#         (rec {
#           systems = [ self.nixosConfigurations.kuraokami.config.nixpkgs.hostPlatform.system ];
#           supportedFeatures = self.nixosConfigurations.kuraokami.config.nix.settings.system-features;
#           maxJobs = if hostName != config.networking.hostName then 24 else 0;
#           speedFactor = 20;
#           sshKey = "/home/jopejoe1/.ssh/github";
#           sshUser = "jopejoe1";
#           hostName = "kuraokami";
#           protocol = "ssh-ng";
#         })
#         (rec {
#           systems = [ self.nixosConfigurations.zap.config.nixpkgs.hostPlatform.system ];
#           supportedFeatures = self.nixosConfigurations.zap.config.nix.settings.system-features;
#           maxJobs = if hostName != config.networking.hostName then 4 else 0;
#           speedFactor = 10;
#           sshUser = "jopejoe1";
#           sshKey = "/home/jopejoe1/.ssh/github";
#           hostName = "zap";
#           protocol = "ssh-ng";
#         })
#       ];
      distributedBuilds = true;
      package = pkgs.lix;
      registry = lib.mkForce ((lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) self.inputs) // {
        self.flake = self;
      });
      nixPath = lib.mkForce [ "/etc/nix/path" ];

    };

    nixpkgs = {
      config ={
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
      overlays = [
        (_self: super: rec {
          firefox-addons = self.inputs.firefox-addons.packages.${config.nixpkgs.hostPlatform.system};
          localPkgs = self.outputs.packages.${config.nixpkgs.hostPlatform.system};
        })
      ];
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

    networking.hosts = {
      "192.168.191.46" = [ "zap" ];
      "192.168.191.142" = [ "kuraokami" ];
      "2a01:4f8:1c1e:7f93::1" = [ "bloomshine.de" ];
    };
  };
}

