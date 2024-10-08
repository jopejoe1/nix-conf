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

  esp8266 = pkgs.callPackage ./esp8266.nix { };
  esp8266-sdk = pkgs.callPackage ./esp8266-sdk.nix {
    inherit esp8266;
  };

  kde-hdr-fix = pkgs.callPackage ./kde-hdr.nix { };
  kde-wallpaper = pkgs.callPackage ./kde-wallpaper.nix { };
}
