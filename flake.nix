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
      url = github:PrismLauncher/PrismLauncher;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware;
    tela-icon-theme = {
      url = "github:vinceliuice/Tela-icon-theme";
      flake = false;
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      prismlauncher,
      nur,
      nixos-hardware,
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
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-gpu-intel
        nixos-hardware.nixosModules.common-gpu-nvidia
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.common-pc-ssd
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [
              prismlauncher.overlays.default
              nur.overlay
              (self: super: {
                tela-icon-theme = super.tela-icon-theme.overrideAttrs (old: {
                  src = inputs.tela-icon-theme;
                });
              })
            ];
          };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };

          system.stateVersion = "23.05";

          nix.registry = {
            home-manager.flake = home-manager;
            nixos-hardware.flake = nixos-hardware;
            nur.flake = nur;
            nixpkgs.flake = nixpkgs;
          };
          nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
        }
      ];
    };
  };
}
