{ self, nixpkgs, inputs }:

let
  mkSystem = system: name: nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = inputs;
    modules = [
      name
      self.outputs.nixosModules.default
    ];
  };
in
{
  kami = mkSystem "x86_64-linux" ./kami;
  yokai = mkSystem "aarch64-linux" ./yokai;
  inugami = mkSystem "aarch64-linux" ./inugami;
  tuny = mkSystem "x86_64-linux" ./tuny;
  installer = mkSystem "x86_64-linux" ./installer;
  steamdeck = mkSystem "x86_64-linux" ./steamdeck;
}
