{ pkgs, ... }:

{

  jopejoe1 = {
    audio = {
      enable = true;
    };
    bluetooth.enable = true;
    local.enable = true;
    nix.enable = true;
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
    boot.systemd.enable = true;
  };

  environment.systemPackages = with pkgs; [ moonlight-qt ];

  time.timeZone = "Europe/Berlin";
  imports = [ ./hardware-configuration.nix ];
}
