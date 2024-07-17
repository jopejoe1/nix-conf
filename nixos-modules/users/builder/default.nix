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
    users.users.jopejoe1 = {
      isNormalUser = true;
      description = "Build User";
      hashedPassword = "$2b$05$Uk84TY/RHlH8DIigUlFYjeorjTlCMEY9wN2pAcw5BLaPoc7dKiSsC";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8oyMpS2hK3gQXyHIIVS6oilgMpemLmfhKKJ6RBMwUh johannes@joens.email"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3pKtvhOOjG1pGJq7cVHS5uWy5IP8y1Ra/ENpmJcqOe root@zap"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFEcNAVRN66mfKmaCpxs++0094Eh4mqXkUwDPZPkIIBB johannes@joens.email"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZDUoC+1lNR2JTY1Q+vhXpuLmKMdVl2OMFLVbQ3cGkw jopejoe1@kuraokami"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKm2igbJ+Ke+dJO3r7wp5ZTreHqC39Sjctca119Bl2yc jopejoe1@zap"
      ];
    };
  };
}
