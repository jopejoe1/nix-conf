{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    nur.url = github:nix-community/NUR;
    flake-compat = { url = github:edolstra/flake-compat; flake = false; };
    libnbtplusplus = { url = github:PrismLauncher/libnbtplusplus; flake = false; };
    flake-utils.url = github:numtide/flake-utils;
    prismlauncher = {
      url = github:PrismLauncher/PrismLauncher;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.libnbtplusplus.follows = "libnbtplusplus";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    nix-darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = github:nix-community/nix-vscode-extensions;
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-hardware, prismlauncher, home-manager, nur, ... }@attrs: {
    nixosConfigurations.yokai = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules = [
        ./yokai.nix
        ./common.nix
        nixos-hardware.nixosModules.pine64-pinebook-pro
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jopejoe1 = import ./home/jopejoe1.nix;
            users.root = import ./home/root.nix;
          };
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [
              #prismlauncher.overlay
              nur.overlay
            ];
          };
        }
      ];
    };
    nixosConfigurations.oni = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./oni.nix
        ./common.nix
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jopejoe1 = import ./home/jopejoe1.nix;
            users.root = import ./home/root.nix;
          };
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [
              prismlauncher.overlay
              nur.overlay
            ];
          };
        }
      ];
    };
    nixosConfigurations.kami = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./kami.nix
        ./common.nix
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jopejoe1 = import ./home/jopejoe1.nix;
            users.root = import ./home/root.nix;
          };
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [
              prismlauncher.overlay
              nur.overlay
            ];
          };
        }
      ];
    };
  };
}
