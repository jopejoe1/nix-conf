{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    kde2nix.url = "github:nix-community/kde2nix";
    nur.url = "github:nix-community/NUR";
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
      inputs.flake-compat.follows = "flake-compat";
      inputs.libnbtplusplus.follows = "libnbtplusplus";
      inputs.nix-filter.follows = "nix-filter";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    tela-icon-theme = {
      url = "github:vinceliuice/Tela-icon-theme";
      flake = false;
    };

    # Dependencys
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    nixpkgs-lib.url = "github:NixOS/nixpkgs/nixos-unstable?dir=lib";
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.flake-utils.follows = "flake-utils";
    };
    yafas = {
      url = "github:UbiqueLambda/yafas";
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.systems.follows = "nix-systems";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    libnbtplusplus = {
      url = "github:PrismLauncher/libnbtplusplus";
      flake = false;
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };
    nix-systems.url = "github:nix-systems/default";
    nix-systems-linux.url = "github:nix-systems/default-linux";
    nix-empty-flake.url = "github:chaotic-cx/nix-empty-flake";
    nix-filter.url = "github:numtide/nix-filter";

    # Patches
    prism-game-options-patch = {
      url =
        "https://patch-diff.githubusercontent.com/raw/PrismLauncher/PrismLauncher/pull/907.patch";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosModules.default = import ./modules;
    homeManagerModules.default = import ./home-modules;
    nixosConfigurations = {
      kami = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/kami
          self.outputs.nixosModules.default
        ];
      };
      yokai = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/yokai
          self.outputs.nixosModules.default
        ];
      };
      inugami = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/inugami
          self.outputs.nixosModules.default
        ];
      };
      tuny = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/tuny
          self.outputs.nixosModules.default
        ];
      };
      steamdeck = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./systems/steamdeck self.outputs.nixosModules.default ];
      };
    };
  };
}
