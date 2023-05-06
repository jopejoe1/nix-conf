{
  inputs = {
    # nixpkgs (Packges and modules)
    #nixpkgs.url = github:NixOS/nixpkgs;#/nixos-unstable;
    #nixpkgs.url = github:jopejoe1/nixpkgs/noto-fonts;
    nixpkgs.url = github:AtaraxiaSjel/nixpkgs/update/ivpn;

    # Nix Hardware (Hardware configs)
    nixos-hardware.url = github:NixOS/nixos-hardware;

    # NUR (User Packges)
    nur.url = github:nix-community/NUR;

    # Home Manger (Dot files)
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    # Nix Darwin (Mac OS support)
    nix-darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Image generators
    nixos-generators = {
      url = github:nix-community/nixos-generators;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixlib";
    };

    # PrismLauncher (git version of PrismLauncher)
    prismlauncher = {
      url = github:PrismLauncher/PrismLauncher;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.libnbtplusplus.follows = "libnbtplusplus";
    };

    # vscode extensions
    nix-vscode-extensions = {
      url = github:nix-community/nix-vscode-extensions;
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = github:snowfallorg/lib;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    snowfall-flake = {
      url = github:snowfallorg/flake;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.snowfall-lib.follows = "snowfall-lib";
    };

    peerix = {
      url = github:cid-chan/peerix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };

    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };

    dns = {
      url = github:kirelagin/dns.nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Dependcies
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };

    flake-utils.url = github:numtide/flake-utils;
    nixlib.url = github:nix-community/nixpkgs.lib;

    naersk = {
      url = github:nix-community/naersk;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus = {
      url = github:gytis-ivaskevicius/flake-utils-plus;
      inputs.flake-utils.follows = "flake-utils";
    };
    comma = {
      url = github:nix-community/comma;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
      inputs.naersk.follows = "naersk";
    };

    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
    };

    libnbtplusplus = {
      url = github:PrismLauncher/libnbtplusplus;
      flake = false;
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
      };
    in
    lib.mkFlake {
      package-namespace = "custom";

      channels-config.allowUnfree = true;

      overlays = with inputs; [
        nur.overlay
        snowfall-flake.overlay
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        peerix.nixosModules.peerix
        agenix.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          system.stateVersion = "23.05";
          nix.registry = {
            flake-utils.flake = flake-utils;
            home-manager.flake = home-manager;
            nix-darwin.flake = nix-darwin;
            nixos-hardware.flake = nixos-hardware;
            nur.flake = nur;
            nixpkgs.flake = nixpkgs;
          };
          nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
          environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
        }

      ];

      systems.hosts.yokai.modules = with inputs; [
        nixos-hardware.nixosModules.pine64-pinebook-pro
      ];

      deploy = lib.mkDeploy { inherit (inputs)  self; };

      checks =
        builtins.mapAttrs
          (system: deploy-lib:
            deploy-lib.deployChecks inputs.self.deploy)
          inputs.deploy-rs.lib;
    };
}
