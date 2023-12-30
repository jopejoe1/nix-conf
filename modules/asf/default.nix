{ config, lib, ... }:

let cfg = config.jopejoe1.asf;
in {
  options.jopejoe1.asf = { enable = lib.mkEnableOption "Enable ASF"; };

  config = lib.mkIf cfg.enable {
    services.archisteamfarm = {
      enable = true;
      web-ui.enable = true;
      settings = {
        LicenseID = "@asfLicenseID@";
        SteamProtocols = 7;
        AutoSteamSaleEvent = true;
      };
      bots.jopejoe1 = {
        username = "jopejoe1";
        enabled = true;
        passwordFile = "/var/lib/asf/pw";
        settings = {
          AutoSteamSaleEvent = true;
          FarmingOrders = 9;
          OnlineStatus = 0;
          RemoteCommunication = 0;
        };
      };
    };
  };
}

