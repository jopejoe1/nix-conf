{ self, nixpkgs, inputs }:

let
  mkSystem = systemConfig: name: nixpkgs.lib.nixosSystem rec {
    system = builtins.replaceStrings ["-unknown-" "-gnu"] ["-" ""] systemConfig;
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
  jurojin = mkSystem "aarch64-unknown-linux-gnu" "jurojin";
  sukuna-biko-na = mkSystem "aarch64-unknown-linux-gnu" "sukuna-biko-na";
  benzaiten = mkSystem "x86_64-unknown-linux-gnu" "benzaiten";
  kamimusubi  = mkSystem "x86_64-unknown-linux-gnu" "kamimusubi";
  ebisu  = mkSystem "x86_64-unknown-linux-gnu" "ebisu";
}
