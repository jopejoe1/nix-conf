{ config, lib, ... }:

let cfg = config.jopejoe1.steam;
in {
  options.jopejoe1.steam = { enable = lib.mkEnableOption "Enable Steam"; };

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}

