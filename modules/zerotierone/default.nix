{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.zerotierone;
in {
  options.jopejoe1.zerotierone = {
    enable = lib.mkEnableOption "Enable zerotierone";
  };

  config = lib.mkIf cfg.enable {
    services.zerotierone.enable = true;
    services.zerotierone.joinNetworks = [ "9e1948db638e9f93" ] ++ lib.optional (config.networking.hostName == "kuraokami") "7c31a21e86f9a75c";
    services.zerotierone.port = 9993;
    environment.systemPackages = with pkgs; [
      moonlight-qt
    ];
  };
}

