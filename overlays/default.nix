{ pkgs, prismlauncher, nur, ... }:

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
}
