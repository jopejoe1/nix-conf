{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    webInterface = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = with pkgs; [ sane-airscan hplipWithPlugin ];
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
