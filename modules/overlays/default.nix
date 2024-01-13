{ config, lib, self, ... }:

let cfg = config.jopejoe1.overlays;
in {
  options.jopejoe1.overlays = {
    enable = lib.mkEnableOption "Enable Overlays";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {

      overlays = [
        self.inputs.prismlauncher.overlays.default

        (_self: super: rec {
          firefox-addons = self.inputs.firefox-addons.packages.${config.nixpkgs.hostPlatform.system};
          localPkgs = self.outputs.packages.${config.nixpkgs.hostPlatform.system};
        })
      ];
    };
  };
}

