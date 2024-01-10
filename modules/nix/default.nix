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
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = true;
        use-xdg-base-directories = true;
      };
      package = pkgs.nix;
      registry = lib.mkForce ((lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) self.inputs) // {
        self.flake = self;
      });
      nixPath = lib.mkForce [ "/etc/nix/path" ];
    };

    nixpkgs = {
      config.allowUnfree = true;
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

    system.stateVersion = "24.05";
    systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576000;
  };
}

