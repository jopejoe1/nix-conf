{
  self,
  nixpkgs,
  inputs,
}:

let
  mkSystem =
    systemConfig: name:
    nixpkgs.lib.nixosSystem rec {
      system = lib.systems.parse.doubleFromSystem systemConfig;
      specialArgs = inputs;
      modules = [
        ./${name}
        self.outputs.nixosModules.default
        {
          system.stateVersion = "24.05";
          nixpkgs.hostPlatform = {
            system = system;
            config = systemConfig;
          };
          networking.hostName = name;
        }
      ];
    };
in
{
  kuraokami = mkSystem "x86_64-unknown-linux-gnu" "kuraokami";
  omoikane = mkSystem "x86_64-unknown-linux-gnu" "omoikane";
  yokai = mkSystem "aarch64-unknown-linux-gnu" "yokai";
  sukuna-biko-na = mkSystem "aarch64-unknown-linux-gnu" "sukuna-biko-na";
  benzaiten = mkSystem "x86_64-unknown-linux-gnu" "benzaiten";
  ebisu = mkSystem "x86_64-unknown-linux-gnu" "ebisu";
  hetzner = mkSystem "x86_64-unknown-linux-gnu" "hetzner";
  zap = mkSystem "x86_64-unknown-linux-gnu" "zap";
}
