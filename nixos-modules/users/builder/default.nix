{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.user.builder;
in
{
  options.jopejoe1.user.builder = {
    enable = lib.mkEnableOption "Enable builder user";
  };

  config = lib.mkIf cfg.enable {
    users.users.builder = {
      isNormalUser = true;
      group = "builder";
      description = "Build User";
      initialHashedPassword = "$2b$05$Uk84TY/RHlH8DIigUlFYjeorjTlCMEY9wN2pAcw5BLaPoc7dKiSsC";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvmivSRjYMSo6+mxChJ7n6k4no4Vkxb6r0In9ZjcqFY root@omoikane"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVR16DtqrdgMq+3Gj1N6XNAjJhHyuG5a4wn7xQ8c49i root@omoikane"
      ];
    };
    users.groups.builder = {};
  };
}
