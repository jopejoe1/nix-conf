{ config, lib, pkgs, ... }:

let
  cfg = config.jopejoe1.steam;
in
{
  options.jopejoe1.steam = {
    enable = lib.mkEnableOption "Enable Steam";
  };

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.steam.gamescopeSession.enable = true;
  };
}

