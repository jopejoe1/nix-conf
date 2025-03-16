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

    environment.sessionVariables =
      let
        makePluginPath =
        format:
          "$HOME/.${format}:" +
          (lib.makeSearchPath format [
            "$HOME/.nix-profile/lib"
            "/run/current-system/sw/lib"
            "/etc/profiles/per-user/$USER/lib"
            ]);
      in
      {
        CLAP_PATH = lib.mkDefault (makePluginPath "clap");
        DSSI_PATH = lib.mkDefault (makePluginPath "dssi");
        LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
        LV2_PATH = lib.mkDefault (makePluginPath "lv2");
        LXVST_PATH = lib.mkDefault (makePluginPath "lxvst");
        VST3_PATH = lib.mkDefault (makePluginPath "vst3");
        VST_PATH = lib.mkDefault (makePluginPath "vst");
      };

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
        "30-echo-cancel" = {
          "context.modules" = [
            {
              name = "libpipewire-module-echo-cancel";
              args = {
                "capture.props" = {
                  "node.name" = "Echo Cancellation Capture";
                };
                "source.props" = {
                  "node.name" = "Echo Cancellation Source";
                };
                "sink.props" = {
                  "node.name" = "Echo Cancellation Sink";
                };
                "playback.props" = {
                  "node.name" = "Echo Cancellation Playback";
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
        "10-snapcast-discover" = {
          "context.modules" = [
            {
              name = "libpipewire-module-snapcast-discover";
              args = {
                "stream.rules" = [
                  {
                    matches = [
                      {
                        "snapcast.ip" = "~.*";
                      }
                    ];
                    actions = {
                      create-stream = {
                      };
                    };
                  }
                ];
              };
            }
          ];
        };
        "10-pulse-discover" = {
          "context.modules" = [
            {
              name = "libpipewire-module-zeroconf-discover";
              args = {
              };
            }
          ];
        };
        "10-x11=bell" = {
          "context.modules" = [
            {
              name = "libpipewire-module-x11-bell";
              args = {
              };
            }
          ];
        };
      };
    };
  };

  imports = [ ./sennheiser-hd660s.nix ];
}
