{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

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
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
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
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages
    tela-icon-theme = {
      url = "github:vinceliuice/Tela-icon-theme";
      flake = false;
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosModules.default = import ./modules;
      homeManagerModules.default = import ./home-modules;
      nixosConfigurations = import ./systems { inherit self inputs nixpkgs; };
      packages = nixpkgs.lib.attrsets.genAttrs nixpkgs.lib.systems.flakeExposed (
        system:
        import ./packages {
          inherit system inputs;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );
      formatter = nixpkgs.lib.attrsets.genAttrs nixpkgs.lib.systems.flakeExposed (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );
    };
}
