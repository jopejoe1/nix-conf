{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.jopejoe1.nix;
in
{
  options.jopejoe1.nix = {
    enable = lib.mkEnableOption "Enable Nix";
  };
  options.jopejoe1.gui = {
    enable = lib.mkEnableOption "Enable GUI";
  };

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
        sandbox = true;
        require-sigs = true;
        max-jobs = "auto";
        allowed-users = [ "*" ];
        trusted-users = [
          "builder"
          "jopejeo1"
          "root"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = true;
        allow-dirty = false;
        use-xdg-base-directories = true;
        keep-going = true;
        builders-use-substitutes = true;
        download-attempts = 1;
        fallback = true;
      };
      buildMachines =
        let
          getMainArch =
            name:
            self.nixosConfigurations.${name}.config.nixpkgs.hostPlatform.system
              or self.nixosConfigurations.${name}.config.nixpkgs.system;
          getArchs =
            name:
            [ (getMainArch name) ]
            ++ self.nixosConfigurations.${name}.config.nix.settings.extra-platforms or [ ];
        in
        [
          {
            systems = getArchs "hetzner";
            supportedFeatures = self.nixosConfigurations.hetzner.config.nix.settings.system-features;
            hostName = "hetzner";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZYQzNPVGRPd0w4V1NDaHhFRENiNS9WbUZYcDZmWUZEM21MMFhFdzFFTDAgcm9vdEBoZXR6bmVyCg==";
            protocol = "ssh-ng";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            maxJobs = 12;
          }
          {
            systems = getArchs "zap";
            supportedFeatures = self.nixosConfigurations.zap.config.nix.settings.system-features;
            hostName = "zap";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5Xb056T0QrM0UzT20xbGpkRUNxWUhaQkZteHA3bTNsS1MxSHBkQnZkZjYgcm9vdEB6YXAK";
            protocol = "ssh-ng";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            maxJobs = 4;
          }
        ];
      distributedBuilds = true;
      package = pkgs.lix;
      registry = lib.mkForce (
        (lib.mapAttrs (_: flake: { inherit flake; })) (
          (lib.filterAttrs (_: lib.isType "flake")) self.inputs
        )
        // {
          self.flake = self;
        }
      );
      nixPath = lib.mkForce [ "/etc/nix/path" ];

    };

    nixpkgs = {
      config = {
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

    environment.etc = lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    }) config.nix.registry;

    environment.systemPackages = with pkgs; [
      nix-index
      nix-prefetch-git
      nixpkgs-review
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        self.outputs.homeManagerModules.default
        self.inputs.catppuccin.homeManagerModules.catppuccin
      ];
    };

    systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576000;

    networking.hosts = {
      "192.168.191.46" = [ "zap" ];
      "192.168.191.142" = [ "kuraokami" ];
      "192.168.194.208" = [ "hetzner" ];
      "192.168.194.232" = [ "omoikane" ];
    };
    users.mutableUsers = false;
  };
}
