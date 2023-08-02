{ ... }:

{
  services.archisteamfarm = {
    enable = true;
    web-ui.enable = true;
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
}
