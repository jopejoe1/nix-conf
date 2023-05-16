{
  inputs = {
    # nixpkgs (Packges and modules)
    nixpkgs.url = github:NixOS/nixpkgs;#/nixos-unstable;
    #nixpkgs.url = github:jopejoe1/nixpkgs/noto-fonts;

    # Nix Hardware (Hardware configs)
    nixos-hardware.url = github:NixOS/nixos-hardware;

    # NUR (User Packges)
    nur.url = github:nix-community/NUR;

    # Home Manger (Dot files)
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.home-manager.follows = "home-manager";
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

    libnbtplusplus = {
      url = github:PrismLauncher/libnbtplusplus;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, prismlauncher, home-manager, nur, ... }@attrs: {
    nixosConfigurations.yokai = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules = [
        ./systems/yokai
        ./common.nix
        nixos-hardware.nixosModules.pine64-pinebook-pro
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
      ];
    };
    nixosConfigurations.oni = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./systems/oni
        ./common.nix
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
      ];
    };
    nixosConfigurations.kami = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./systems/kami
        ./common.nix
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
      ];
    };
  };
}
