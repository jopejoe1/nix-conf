{ config, lib, ... }:

let cfg = config.jopejoe1.root;
in {
  options.jopejoe1.root = { enable = lib.mkEnableOption "Enable root user"; };

  config = lib.mkIf cfg.enable {
    users.users.root = { initialPassword = "password"; };
  };
  imports = [ ./home.nix ];
}

