{ inputs, pkgs, system }:

{
  tela-icon-theme-git = pkgs.tela-icon-theme.overrideAttrs {
    src = inputs.tela-icon-theme;
  };

  openrgb-git = pkgs.openrgb.overrideAttrs {
    src = inputs.openrgb;
  };

  libadwaita-follow-theme = pkgs.libadwaita.overrideAttrs (old: {
    patches = (old.patches or [ ])++ [ ./adwaita-theming-support.patch ];
    doCheck = false;
  });

  prismlauncher-withExtraStuff = inputs.prismlauncher.packages.${system}.prismlauncher.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      inputs.prism-game-options-patch
      ./prism-ftb.patch
    ];
  });
}