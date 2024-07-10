{ config, lib, ... }:

let
  cfg = config.jopejoe1.audio;
in
{
  config = lib.mkIf cfg.sennheiser-hd-660s {
    services.pipewire = {
      extraConfig.pipewire."20-Senheiser-HD660S" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Senheiser HD 660 S Equaliser";
              "media.name" = "Senheiser HD 660 S Equaliser";
              "filter.graph" = {
                nodes = [
                  {
                    type = "builtin";
                    name = "eq_band_1";
                    label = "bq_highshelf";
                    control = {
                      "Freq" = 0.0;
                      "Q" = 1.0;
                      "Gain" = -6.4;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_2";
                    label = "bq_lowshelf";
                    control = {
                      "Freq" = 105.0;
                      "Q" = 0.7;
                      "Gain" = 6.5;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_3";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 178.0;
                      "Q" = 0.49;
                      "Gain" = -3.2;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_4";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 1222.0;
                      "Q" = 2.34;
                      "Gain" = -2.3;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_5";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 5470.0;
                      "Q" = 4.4;
                      "Gain" = -7.3;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_6";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 7899.0;
                      "Q" = 0.68;
                      "Gain" = 6.5;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_7";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 784.0;
                      "Q" = 3.52;
                      "Gain" = -0.4;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_8";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 2250.0;
                      "Q" = 3.58;
                      "Gain" = 1.3;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_9";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 3380.0;
                      "Q" = 2.84;
                      "Gain" = -0.9;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_10";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 6701.0;
                      "Q" = 6.0;
                      "Gain" = 1.2;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_11";
                    label = "bq_highshelf";
                    control = {
                      "Freq" = 10000.0;
                      "Q" = 0.7;
                      "Gain" = -1.1;
                    };
                  }
                ];
                links = [
                  {
                    output = "eq_band_1:Out";
                    input = "eq_band_2:In";
                  }
                  {
                    output = "eq_band_2:Out";
                    input = "eq_band_3:In";
                  }
                  {
                    output = "eq_band_3:Out";
                    input = "eq_band_4:In";
                  }
                  {
                    output = "eq_band_4:Out";
                    input = "eq_band_5:In";
                  }
                  {
                    output = "eq_band_5:Out";
                    input = "eq_band_6:In";
                  }
                  {
                    output = "eq_band_6:Out";
                    input = "eq_band_7:In";
                  }
                  {
                    output = "eq_band_7:Out";
                    input = "eq_band_8:In";
                  }
                  {
                    output = "eq_band_8:Out";
                    input = "eq_band_9:In";
                  }
                  {
                    output = "eq_band_9:Out";
                    input = "eq_band_10:In";
                  }
                  {
                    output = "eq_band_10:Out";
                    input = "eq_band_11:In";
                  }
                ];
              };
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
              "capture.props" = {
                "node.name" = "effect_input.eq11";
                "media.class" = "Audio/Sink";
              };
              "playback.props" = {
                "node.name" = "effect_output.eq11";
                "node.passive" = true;
              };
            };
          }
        ];
      };
    };
  };
}
