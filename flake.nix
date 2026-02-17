{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
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
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      forSystems = f: nixpkgs.lib.attrsets.genAttrs nixpkgs.lib.systems.flakeExposed (system: f system);
      pkgs' = f: (nixpkgs.lib.nixosSystem {
        modules = [
          self.outputs.nixosModules.default
          {
            nixpkgs = {
              system = f;
            };
          }
        ];
      }).pkgs;
      mkForSystems = data: forSystems (system: data (pkgs' system)); 
    in
    {
      nixosModules.default = import ./nixos-modules self;
      homeManagerModules.default = import ./home-modules;
      overlays.default = import ./overlays;
      nixosConfigurations = import ./systems { inherit self nixpkgs; };
      formatter = mkForSystems (pkgs:  pkgs.jopejoe1.fmt);
      legacyPackages = mkForSystems (pkgs: pkgs);
    };
}
