{ inputs, pkgs, system }:

{
  tela-icon-theme-git = pkgs.tela-icon-theme.overrideAttrs {
    src = inputs.tela-icon-theme;
  };

  libadwaita-follow-theme = pkgs.libadwaita.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./adwaita-theming-support.patch ];
    doCheck = false;
  });

  prismlauncher-withExtraStuff = inputs.prismlauncher.packages.${system}.prismlauncher.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./prism-ftb.patch
    ];
  });

  nixos-anywhere = inputs.nixos-anywhere.packages.${system}.nixos-anywhere;
}
