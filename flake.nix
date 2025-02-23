{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    # Outputs
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nether = {
      url = "github:Lassulus/nether";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nuschtos = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utility
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    # Flake Stuff
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      forSystems = f: nixpkgs.lib.attrsets.genAttrs nixpkgs.lib.systems.flakeExposed (system: f system);
      pkgs' = system: nixpkgs.legacyPackages.${system};
      treefmtEval = system: treefmt-nix.lib.evalModule (pkgs' system) ./treefmt.nix;
    in
    {
      modules.default = import ./modules;
      nixosModules.default = import ./nixos-modules;
      homeManagerModules.default = import ./home-modules;
      nixosConfigurations = import ./systems { inherit self inputs nixpkgs; };
      packages = forSystems (
        system:
        import ./packages {
          inherit system inputs;
          pkgs = pkgs' system;
        }
      );
      formatter = forSystems (system: (treefmtEval system).config.build.wrapper);
      checks = forSystems (system: {
        formatting = (treefmtEval system).config.build.check self;
      });
    };
}
