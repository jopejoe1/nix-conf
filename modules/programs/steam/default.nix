{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.programs.steam;
in
{
  options.custom.programs.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable Steam.";
  };

  config = mkIf cfg.enable {
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
