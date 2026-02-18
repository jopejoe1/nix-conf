{
  config,
  lib,
  pkgs,
  systems,
  ...
}:

let
  cfg = config.jopejoe1.nix;
in
{
  options.jopejoe1.nix = {
    enable = lib.mkEnableOption "Enable Nix";
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
          "auto-allocate-uids"
          "cgroups"
          "fetch-closure"
        ];
        auto-allocate-uids = true;
        use-cgroups = true;
        warn-dirty = true;
        use-xdg-base-directories = true;
        keep-going = true;
        builders-use-substitutes = true;
        download-attempts = 1;
        fallback = true;
        allowed-uris = [
          "github:"
          "gitlab:"
        ];
      };
      buildMachines =
        let
          getMainArch =
            name: systems.${name}.config.nixpkgs.hostPlatform.system or systems.${name}.config.nixpkgs.system;
          getArchs =
            name: [ (getMainArch name) ] ++ systems.${name}.config.nix.settings.extra-platforms or [ ];
        in
        lib.filter (builder: builder.hostName != config.networking.hostName) [
          {
            systems = getArchs "hetzner";
            supportedFeatures = systems.hetzner.config.nix.settings.system-features;
            hostName = "hetzner";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxPNndNaFU1dndSdFV6ZytPVjJjdHF1K3FvaGVpQnlTbkp5alUwT1kwN0wgcm9vdEBoZXR6bmVyCg==";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            speedFactor = 5;
            maxJobs = (lib.elemAt systems.hetzner.config.hardware.facter.report.hardware.cpu 0).cores;
          }
          {
            systems = getArchs "zap";
            supportedFeatures = systems.zap.config.nix.settings.system-features;
            hostName = "zap";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUo3NGsyb0ZNcjNGbTI2ZFRmZ2VZUklKdEhLNnN4clJ4ZnY4dkU0QXJKZVMgcm9vdEB6YXAK";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            maxJobs = (lib.elemAt systems.zap.config.hardware.facter.report.hardware.cpu 0).cores;
          }
          {
            systems = getArchs "kuraokami";
            supportedFeatures = systems.kuraokami.config.nix.settings.system-features;
            hostName = "kuraokami";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVB6T0NJZkp4RHRoTUVxZWxreGxSYnIrSEFFTTRCZWE3YnlDTEhYbTdpYS8gcm9vdEBrdXJhb2thbWkK";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            speedFactor = 10;
            maxJobs = (lib.elemAt systems.kuraokami.config.hardware.facter.report.hardware.cpu 0).cores;
          }
        ];
      distributedBuilds = true;
      package = pkgs.lixPackageSets.latest.lix;
      nixPath = lib.mkForce [ "/etc/nix/path" ];

    };
    niri-flake.cache.enable = false;
    nixpkgs = {
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        allowAliases = false;
      };
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
      overwriteBackup = true;
      extraSpecialArgs = {
        systemConfig = config;
      };
    };

    systemd.services.nix-daemon = {
      serviceConfig = {
        EnvironmentFile = "/var/nixenv";
        LimitNOFILE = lib.mkForce 1048576000;
      };
    };
  };
}
