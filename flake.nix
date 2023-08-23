{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
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
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.flake-utils.follows = "flake-utils";
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

    # Patches
    prism-game-options-patch = {
      url = "https://patch-diff.githubusercontent.com/raw/PrismLauncher/PrismLauncher/pull/907.patch";
      flake = false;
    };
    prism-ftb-patch = {
      url = "https://github.com/AdenMck/PrismLauncher/commit/36df231f7ad5f8d54d08c4d2c5f99f6d000fc507.patch";
      flake = false;
    };
  };

  outputs = inputs@{
      nixpkgs,
      home-manager,
      nur,
      nixos-hardware,
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
          ./modules/editor
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
        ];
      };
    };
  };
}
