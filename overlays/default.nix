{ prismlauncher, nur, self, pkgs, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      prismlauncher.overlays.default
      nur.overlay

      (_self: super: rec {

        tela-icon-theme = super.tela-icon-theme.overrideAttrs (_old: {
          src = self.inputs.tela-icon-theme;
        });

        libreoffice-fresh-unwrapped = super.libreoffice-fresh-unwrapped.overrideAttrs (_old: {
          doCheck = false;
        });

        haskellPackages = super.haskellPackages.override {
          overrides = hsSelf: hsSuper: {
            crypton  = super.haskell.lib.overrideCabal hsSuper.crypton  (oa: {
              doCheck = false;
            });
            crypton-x509-validation  = super.haskell.lib.overrideCabal hsSuper.crypton-x509-validation  (oa: {
              doCheck = false;
            });
            tls = super.haskell.lib.overrideCabal hsSuper.tls  (oa: {
              doCheck = false;
            });
            tls_1_9_0 = super.haskell.lib.overrideCabal hsSuper.tls_1_9_0  (oa: {
              doCheck = false;
            });
            typst = super.haskell.lib.overrideCabal hsSuper.typst  (oa: {
              doCheck = false;
            });
          };
        };

        python311 = super.python311.override {
          packageOverrides = py-self: py-super: {
            numpy = py-super.numpy.overridePythonAttrs(old: {
              disabledTests = [ "test_umath_accuracy" ] ++ (old.disabledTests or []);
              doCheck = false;
              doInstallCheck = false;
              doPytestCheck = false;
            });
            pandas = py-super.pandas.overridePythonAttrs(old: {
              disabledTests = [ "test_rolling" ] ++ (old.disabledTests or []);
            });
          };
        };

        python11Packages = python311.pkgs;

        prismlauncher = super.prismlauncher.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            self.inputs.prism-game-options-patch
            ../patches/prism-ftb.patch
          ];
        });

        #noto-fonts-color-emoji = pkgs.noto-fonts-color-emoji_withExtraFlags;

        libadwaita = super.libadwaita.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            ../patches/adwaita-theming-support.patch
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
