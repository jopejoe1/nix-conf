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
      url = github:vinceliuice/Tela-icon-theme;
      flake = false;
    };

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
      self,
      nixpkgs,
      home-manager,
      prismlauncher,
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
                  prismlauncher = super.prismlauncher.overrideAttrs (old: {
                    patches = (old.patches or []) ++ [
                      inputs.prism-game-options-patch
                      inputs.prism-ftb-patch
                    ];
                  });
                  libadwaita = super.libadwaita.overrideAttrs (old: {
                    patches = (old.patches or []) ++ [
                      ./patches/adwaita-theming-support.patch
                    ];
                    doCheck = false;
                  });
                  discord = (super.discord.overrideAttrs (old: {
                    desktopItem = old.desktopItem.override (old: { exec = old.exec + " --disable-gpu-sandbox"; });
                  })).override {
                    withOpenASAR = true;
                    withVencord = true;
                    withTTS = true;
                  };
                  catppuccin-plymouth = super.catppuccin-plymouth.override {
                    variant = "frappe";
                  };
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
          nixos-hardware.nixosModules.pine64-pinebook-pro
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
                  discord = super.discord.overrideAttrs (old: {
                    desktopItem = old.desktopItem.override (old: { exec = old.exec + " --disable-gpu-sandbox"; });
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
  };
}
