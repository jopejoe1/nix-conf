{ config, lib, ... }:

let cfg = config.jopejoe1.root;
in {
  options.jopejoe1.root = { enable = lib.mkEnableOption "Enable root user"; };

  config = lib.mkIf cfg.enable {
    users.users.root = { i
      nitialPassword = "password";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8oyMpS2hK3gQXyHIIVS6oilgMpemLmfhKKJ6RBMwUh johannes@joens.email"
      ];
    };
  };
  imports = [ ./home.nix ];
}

