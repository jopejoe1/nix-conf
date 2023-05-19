{
  description = "jopejoe1 NixOS configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://prismlauncher.cachix.org"
      "https://nixos-search.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
      "nixos-search.cachix.org-1:1HV3YF8az4fywnH+pAd+CXFEdpTXtv9WpoivPi+H70o="
    ];
  };

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    nur.url = github:nix-community/NUR;
    home-manager= {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
  }: {
    nixosConfigurations.kami = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        ./systems/kami
        ./common.nix
      ];
    };
  };
}
