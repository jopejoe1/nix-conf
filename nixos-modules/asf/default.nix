# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

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
      licenseFile = "/var/lib/archisteamfarm/licenseID";
      settings = {
        SteamProtocols = 7;
        SteamTokenDumperPluginEnabled = true;
      };
      bots.jopejoe1 = {
        username = "jopejoe1";
        enabled = true;
        passwordFile = "/var/lib/archisteamfarm/jopejoe1PW";
        settings = {
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
