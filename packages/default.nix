{
  inputs,
  pkgs,
  system,
}:

rec {
  libadwaita-follow-theme = pkgs.libadwaita.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./adwaita-theming-support.patch ];
    doCheck = false;
  });

  nixos-anywhere = inputs.nixos-anywhere.packages.${system}.nixos-anywhere;
}
