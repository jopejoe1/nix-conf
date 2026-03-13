let
  npins = import ../npins;
  fpkgs = import npins.nixpkgs { };
  nixpkgs = npins.nixpkgs { pkgs = fpkgs; };
  lib = import "${nixpkgs}/lib" { };
  inherit (lib.systems.parse) doubleFromSystem mkSystemFromString;
  mkSystem =
    systemConfig: name:
    import "${nixpkgs}/nixos" {
      specialArgs = {
        inherit systems npins fpkgs;
      };
      configuration.imports = [
        ./${name}
        ../nixos-modules
        {
          system.stateVersion = "24.05";
          nixpkgs = {
            hostPlatform = {
              system = doubleFromSystem (mkSystemFromString systemConfig);
              config = systemConfig;
            };
          };
          networking.hostName = name;
        }
      ];
    };
  systems = {
    kuraokami = mkSystem "x86_64-unknown-linux-gnu" "kuraokami";
    omoikane = mkSystem "x86_64-unknown-linux-gnu" "omoikane";
    yokai = mkSystem "aarch64-unknown-linux-gnu" "yokai";
    sukuna-biko-na = mkSystem "aarch64-unknown-linux-gnu" "sukuna-biko-na";
    benzaiten = mkSystem "x86_64-unknown-linux-gnu" "benzaiten";
    ebisu = mkSystem "x86_64-unknown-linux-gnu" "ebisu";
    hetzner = mkSystem "x86_64-unknown-linux-gnu" "hetzner";
    zap = mkSystem "x86_64-unknown-linux-gnu" "zap";
  };
in
systems
