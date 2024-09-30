{
  inputs,
  pkgs,
  system,
}:

{
  libadwaita-follow-theme = pkgs.libadwaita.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./adwaita-theming-support.patch ];
    doCheck = false;
  });

  nixos-anywhere = inputs.nixos-anywhere.packages.${system}.nixos-anywhere;

  kde-hdr-fix = pkgs.callPackage ./kde-hdr.nix { };
  kde-wallpaper = pkgs.callPackage ./kde-wallpaper.nix { };
}
