{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.audio;
in
{
  options.jopejoe1.audio = {
    enable = lib.mkEnableOption "Enable Audio";
    sennheiser-hd-660s = lib.mkEnableOption "Equalizer for Sennheiser HD 660S";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      systemWide = false;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;

      extraConfig.pipewire = {
        "30-noise-filter" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Noise Canceling source";
                "media.name" = "Noise Canceling source";
                "filter.graph" = {
                  nodes = [
                    {
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                      label = "noise_suppressor_mono";
                      control = {
                        "VAD Threshold (%)" = 50.0;
                        #"VAD Grace Period (ms)" = 0;
                        "Retroactive VAD Grace (ms)" = 50;
                      };
                    }
                  ];
                };
                "capture.props" = {
                  "node.name" = "capture.rnnoise_source";
                  "node.passive" = true;
                  "audio.rate" = 48000;
                };
                "playback.props" = {
                  "node.name" = "rnnoise_source";
                  "media.class" = "Audio/Source";
                  "audio.rate" = 48000;
                };
              };
            }
          ];
        };
        "10-raop-discover" = {
          "context.modules" = [
            {
              name = "libpipewire-module-raop-discover";
              args = {
                "stream.rules" = [
                  {
                    matches = [
                      {
                        "raop.ip" = "~.*";
                      }
                    ];
                    actions = {
                      create-stream = {
                        "stream.props" = {
                        };
                      };
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };

  imports = [ ./sennheiser-hd660s.nix ];
}
