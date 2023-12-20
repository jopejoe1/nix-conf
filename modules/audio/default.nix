{ pkgs, ... }:

{
  imports = [
    ./sennheiser-hd660s.nix
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    systemWide = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;

    extraConfig.pipewire."30-noise-filter" = {
      "context.modules" = [{
        name = "libpipewire-module-filter-chain";
        args = {
          "node.description" = "Noise Canceling source";
          "media.name" = "Noise Canceling source";
          "filter.graph" = {
            nodes = [{
              type = "ladspa";
              name = "rnnoise";
              plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
              label = "noise_suppressor_mono";
              control = {
                "VAD Threshold (%)" = 50.0;
                "VAD Grace Period (ms)" = 200;
                "Retroactive VAD Grace (ms)" = 0;
              };
            }];
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
      }];
    };
  };

  hardware.pulseaudio.enable = false;
}

