{ lib, pkgs, ... }:

{
  systemd.timers."moodle-dl" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "6h";
      Unit = "moodle-dl.service";
    };
  };

  systemd.services."moodle-dl" = {
    script = ''
      ${lib.getExe pkgs.moodle-dl}
      ${lib.getExe pkgs.git} -C /var/moodle-dl add *
      ${lib.getExe pkgs.git} -C /var/moodle-dl commit -m "moodle-dl updated on `$(${pkgs.coreutils}/bin/date)`"
    '';
    path = [pkgs.openssh];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
