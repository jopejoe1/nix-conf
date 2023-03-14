{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.hardware.audio;
in
{
  options.custom.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };

    hardware.pulseaudio.enable = mkForce false;

    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
    ];
  };
}
