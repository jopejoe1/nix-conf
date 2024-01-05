{ config, lib, self, ... }:

let cfg = config.jopejoe1.overlays;
in {
  options.jopejoe1.overlays = {
    enable = lib.mkEnableOption "Enable Overlays";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {

      overlays = [
        self.inputs.prismlauncher.overlays.default

        (_self: super: rec {

          firefox-addons = self.inputs.firefox-addons.packages."${config.nixpkgs.hostPlatform.system}";

          tela-icon-theme = super.tela-icon-theme.overrideAttrs
            (_old: { src = self.inputs.tela-icon-theme; });

          openrgb = super.openrgb.overrideAttrs
            (_old: { src = self.inputs.openrgb; });

          prismlauncher = super.prismlauncher.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              self.inputs.prism-game-options-patch
              ./prism-ftb.patch
            ];
          });

          libadwaita = super.libadwaita.overrideAttrs (old: {
            patches = (old.patches or [ ])
              ++ [ ./adwaita-theming-support.patch ];
            doCheck = false;
          });

          discord = (super.discord.overrideAttrs (old: {
            desktopItem = old.desktopItem.override
              (old: { exec = old.exec + " --disable-gpu-sandbox"; });
          })).override {
            withOpenASAR = true;
            withVencord = true;
            withTTS = true;
          };

          catppuccin-plymouth =
            super.catppuccin-plymouth.override { variant = "frappe"; };
        })
      ];
    };
  };
}

