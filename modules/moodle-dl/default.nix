{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.moodle-dl;
in {
  options.jopejoe1.moodle-dl = {
    enable = lib.mkEnableOption "Enable moodle-dl";
  };

  config = lib.mkIf cfg.enable {
    systemd.timers."moodle-dl" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "1h";
        Unit = "moodle-dl.service";
      };
    };

    systemd.services."moodle-dl" = {
      script = ''
        ${lib.getExe pkgs.moodle-dl} --path /var/moodle-dl
        ${lib.getExe pkgs.git} -C /var/moodle-dl add .
        ${
          lib.getExe pkgs.git
        } -C /var/moodle-dl commit -m "moodle-dl updated on `$(${pkgs.coreutils}/bin/date)`"
      '';
      path = [ pkgs.openssh ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}

