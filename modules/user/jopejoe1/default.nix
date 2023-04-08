{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.user.jopejoe1;
in
{
  options.custom.user.jopejoe1 = with types; {
    enable = mkBoolOpt false "Enable the user jopejoe1";
  };

  config = mkIf cfg.enable {
    custom.user.jopejoe1.home.enable = true;
    users.users.jopejoe1 = {
      isNormalUser = true;
      description = "jopejoe1 🚫";
      initialPassword = "password";
      extraGroups = [ "wheel"]
        ++ lib.optionals config.custom.hardware.printing.enable [ "scanner" "lp"]
        ++ lib.optional config.networking.networkmanager.enable "networkmanger";
      packages = with pkgs; [ git kate libsForQt5.ark element-desktop libreoffice-qt texlive.combined.scheme-full tela-icon-theme ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCUWMJyy2qq2aacVv/J5raugh7UKEmCs+JpagQh30mYqwLV9YQtOfZ+A3Q1qOOLPHTTciLydsfz8K2jBGXEv49uqz9P33aw63RzSaLdcnXhBJRmZvJ3AujLBKDIo24PLOVasogtu01eyQALTg4npX+qlti2UsxLY5O8E5paFJvJ+5rGE3/34c4xA9xthUm7G7SCSt4AhVXwPGB1tqz1KLqGdTJQhvy80laEDSV4tAYpiabmjhNFKGpf8T7afnw1MzKXz+ba6exBcGaJfy2Q24DLztZsW7fsTE1iCdkbcmos9/jUR6NooKFgDr0M4CL2TVZB5pECSiOev06GMnLt+vpxjFL29YeGMaVMmNCedkL1z1mftbXLEL7934kEK9FpEpSwzbRTJ7iPvfYZuTHiT6fi2Ep7n+zzRS+/ZgDUDLSqZYEBmE4dO4LgcqzOsJo5EgoyLGoqQ4OpvPRY12T3rCWUfEgOCXgToF0WlUyxCaPZCfvUjM4LXNlIy/dtivMxMs8= jopejoe1@yokai"
      ];
    };
  };
}
