{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
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
        {
          nixpkgs = {
            config.allowUnfree = true;
            #overlays = [ prismlauncher.overlay nur.overlay ];
          };
          system.stateVersion = "23.05";
        }
      ];
    };
  };
}
