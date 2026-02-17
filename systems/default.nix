{
  self,
  nixpkgs,
}:

let
  inherit (nixpkgs) lib;
  inherit (lib.systems.parse) doubleFromSystem mkSystemFromString;
  mkSystem =
    systemConfig: name:
    lib.nixosSystem {
      specialArgs = {
        inherit systems;
        inherit (self.inputs) nixos-hardware srvos;
      };
      modules = [
        ./${name}
        self.outputs.nixosModules.default
        {
          system.stateVersion = "24.05";
          nixpkgs = {
            hostPlatform = {
              system = doubleFromSystem (mkSystemFromString systemConfig);
              config = systemConfig;
            };
          };
          networking.hostName = name;
          nix = {
            registry = lib.mkForce (
              (lib.mapAttrs (_: flake: { inherit flake; })) (
                (lib.filterAttrs (_: lib.isType "flake")) self.inputs
              )
              // {
                self.flake = self;
              }
            );
          };
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
    copy-pasta = mkSystem "x86_64-unknown-linux-gnu" "copy-pasta";
  };
in
systems
