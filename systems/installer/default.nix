{ config, pkgs, lib, ... }:

{
  jopejoe1 = {
    audio = {
      enable = true;
    };
    local.enable = true;
    nix.enable = true;
    plasma6.enable = true;
    overlays.enable = true;
    jopejoe1.enable = true;
    root.enable = true;
  };

  networking = {
    hostName = "installer";
    wireless.enable = lib.mkForce false;
  };

  nixpkgs = {
    hostPlatform = {
      system = "x86_64-linux";
      config = "x86_64-unknown-linux-gnu";
    };
  };

  time.timeZone = "Europe/Berlin";


  environment.systemPackages = with pkgs; [
    # Calamares for graphical installation
    libsForQt5.kpmcore
    calamares-nixos
    (pkgs.makeAutostartItem { name = "io.calamares.calamares"; package = pkgs.calamares-nixos; })
    calamares-nixos-extensions
    # Get list of locales
    glibcLocales
    # Theming
    catppuccin-kvantum
    catppuccin-kde
    catppuccin-gtk
    tela-icon-theme
  ];

  i18n.supportedLocales = [ "all" ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  programs = {
    xwayland.enable = true;
    kdeconnect.enable = true;
  };
  console = {
    enable = true;
  };
}
