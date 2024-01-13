{ self, nixpkgs, inputs }:

{
  kami = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./kami
      self.outputs.nixosModules.default
    ];
  };
  yokai = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = inputs;
    modules = [
      ./yokai
      self.outputs.nixosModules.default
    ];
  };
  inugami = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = inputs;
    modules = [
      ./inugami
      self.outputs.nixosModules.default
    ];
  };
  tuny = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./tuny
      self.outputs.nixosModules.default
    ];
  };
  installer = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./installer
      self.outputs.nixosModules.default
    ];
  };
  steamdeck = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [ ./steamdeck self.outputs.nixosModules.default ];
  };
}
