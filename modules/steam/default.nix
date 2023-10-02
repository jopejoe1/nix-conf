{ pkgs, ... }:

{
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.steam.gamescopeSession.enable = true;

  chaotic.steam.extraCompatPackages = with pkgs; [
    luxtorpeda
    proton-ge-custom
  ];
}
