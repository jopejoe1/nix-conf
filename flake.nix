{
  description = "jopejoe1 NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    home-manager= {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      prismlauncher,
      nur,
      ...
  }: {
    nixosConfigurations.kami = nixpkgs.lib.nixosSystem {
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
        ./modules/ssh
        ./modules/steam
        ./modules/users/jopejoe1
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ prismlauncher.overlays.default nur.overlay ];
          };
          system.stateVersion = "23.05";
        }
      ];
    };
  };
}
