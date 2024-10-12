{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.jopejoe1.sops;
in
{
  options.jopejoe1.sops = {
    enable = (lib.mkEnableOption "Enable sops") // { default = true;};
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../secrets/main.yaml;
      age = {
        keyFile = "/home/jopejoe1/.config/sops/age/keys.txt";

      };
    };
  };
}
