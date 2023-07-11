{ pkgs, ... }:

{
  imports = [
    ./home.nix
  ];

  users.users.jopejoe1 = {
    isNormalUser = true;
    description = "Johannes Jöns";
    initialPassword = "password";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      git
      kate
      libsForQt5.ark
      libreoffice-qt
      texlive.combined.scheme-full
      tela-icon-theme
      lutris
      bottles
    ] ++ lib.optionals (system == "x86_64-linux") [ discord google-chrome ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCUWMJyy2qq2aacVv/J5raugh7UKEmCs+JpagQh30mYqwLV9YQtOfZ+A3Q1qOOLPHTTciLydsfz8K2jBGXEv49uqz9P33aw63RzSaLdcnXhBJRmZvJ3AujLBKDIo24PLOVasogtu01eyQALTg4npX+qlti2UsxLY5O8E5paFJvJ+5rGE3/34c4xA9xthUm7G7SCSt4AhVXwPGB1tqz1KLqGdTJQhvy80laEDSV4tAYpiabmjhNFKGpf8T7afnw1MzKXz+ba6exBcGaJfy2Q24DLztZsW7fsTE1iCdkbcmos9/jUR6NooKFgDr0M4CL2TVZB5pECSiOev06GMnLt+vpxjFL29YeGMaVMmNCedkL1z1mftbXLEL7934kEK9FpEpSwzbRTJ7iPvfYZuTHiT6fi2Ep7n+zzRS+/ZgDUDLSqZYEBmE4dO4LgcqzOsJo5EgoyLGoqQ4OpvPRY12T3rCWUfEgOCXgToF0WlUyxCaPZCfvUjM4LXNlIy/dtivMxMs8= jopejoe1@yokai"
    ];
  };
}

