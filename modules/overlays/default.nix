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
        self.inputs.nur.overlay

        (_self: super: rec {

          tela-icon-theme = super.tela-icon-theme.overrideAttrs
            (_old: { src = self.inputs.tela-icon-theme; });

          prismlauncher = super.prismlauncher.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              self.inputs.prism-game-options-patch
              ./prism-ftb.patch
            ];
          });

          #noto-fonts-color-emoji = pkgs.noto-fonts-color-emoji_withExtraFlags;

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

