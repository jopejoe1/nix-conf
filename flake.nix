{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:jopejoe1/nixpkgs/noto-emoji-unstale";
    nur.url = "github:nix-community/NUR";
    nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.systems.follows = "nix-systems-linux";
      inputs.compare-to.follows = "nix-empty-flake";
      inputs.yafas.follows = "yafas";
    };
    home-manager= {
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
      url = "https://patch-diff.githubusercontent.com/raw/PrismLauncher/PrismLauncher/pull/907.patch";
      flake = false;
    };
  };

  outputs = inputs@{
      nixpkgs,
      home-manager,
      nur,
      nixos-hardware,
      nyx,
      ...
  }: {
    nixosConfigurations = {
      kami = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/kami
          ./modules/audio
          ./modules/bluetooth
          ./modules/local
          ./modules/nix
          ./modules/plasma
          ./modules/printing
          #./modules/ssh
          ./modules/steam
          ./modules/asf
          ./modules/minecraft-server
          ./modules/kate
          ./modules/auto-update
          ./modules/services/repo-sync
          ./modules/users/jopejoe1
          ./modules/users/root
          ./overlays
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-gpu-nvidia
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-hidpi
          nixos-hardware.nixosModules.common-pc-ssd
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          nyx.nixosModules.default
        ];
      };
      yokai = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/yokai
          ./modules/audio
          ./modules/bluetooth
          ./modules/local
          ./modules/nix
          ./modules/plasma
          ./modules/printing
          #./modules/ssh
          ./modules/users/jopejoe1
          ./modules/users/root
          ./overlays
          nixos-hardware.nixosModules.pine64-pinebook-pro
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          nyx.nixosModules.default
        ];
      };
      inugami = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/inugami
          ./modules/audio
          ./modules/bluetooth
          ./modules/local
          ./modules/nix
          ./modules/kodi
          ./modules/auto-update
          ./overlays
          nixos-hardware.nixosModules.raspberry-pi-4
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          nyx.nixosModules.default
        ];
      };
      tuny = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./systems/tuny
          ./modules/audio
          ./modules/bluetooth
          ./modules/local
          ./modules/nix
          ./modules/auto-update
          #./overlays
          nixos-hardware.nixosModules.common-cpu-intel
          #nixos-hardware.nixosModules.common-gpu-nvidia
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-laptop-hdd
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          nyx.nixosModules.default
        ];
      };
    };
  };
}
