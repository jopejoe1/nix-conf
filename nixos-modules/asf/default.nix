{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.asf;
in
{
  options.jopejoe1.asf = {
    enable = lib.mkEnableOption "Enable ASF";
  };

  config = lib.mkIf cfg.enable {
    services.archisteamfarm = {
      enable = true;
      web-ui.enable = true;
      ipcPasswordFile = "/var/lib/archisteamfarm/icppw";
      settings = {
        LicenseID = null;
        SteamProtocols = 7;
        SteamTokenDumperPluginEnabled = true;
        #AutoSteamSaleEvent = true;
      };
      bots.jopejoe1 = {
        username = "jopejoe1";
        enabled = true;
        passwordFile = "/var/lib/archisteamfarm/jopejoe1PW";
        settings = {
          #AutoSteamSaleEvent = true;
          FarmingOrders = [ 9 ];
          OnlineStatus = 0;
          RemoteCommunication = 0;
          EnableFreePackages = true;
          FreePackagesLimit = 30;
          FreePackagesFilters = [
            {
              IgnoredTypes = [ ];
              PlaytestMode = 3;
            }
          ];
        };
      };
    };
  };
}
