{
  inputs = {
    # nixpkgs (Packges and modules)
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

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
    libnbtplusplus = {
      url = github:PrismLauncher/libnbtplusplus;
      flake = false;
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
        prismlauncher.overlay
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        peerix.nixosModules.peerix
        agenix.nixosModules.default
        {
          #home-manager = {
           # useGlobalPkgs = true;
           # useUserPackages = true;
          #};
          system.stateVersion = "22.11";
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
