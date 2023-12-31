{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.jopejoe1;
in {
  options.jopejoe1.jopejoe1 = {
    enable = lib.mkEnableOption "Enable jopejoe1 user";
  };

  config = lib.mkIf cfg.enable {
    users.users.jopejoe1 = {
      isNormalUser = true;
      description = "Johannes Jöns";
      initialPassword = "password";
      extraGroups = [ "wheel" "networkmanager" "pipewire" "audio" ];
      uid = 1000;
      packages = with pkgs;
        [ libsForQt5.kate libsForQt5.ark texlive.combined.scheme-full ]
        ++ lib.optionals (config.system == "x86_64-linux") [
          discord
          lutris
          bottles
        ];
    };
  };

  imports = [ ./home.nix ];
}
