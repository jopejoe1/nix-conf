{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.moodle-dl;
in
{
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
        moodle-dl --path /var/lib/moodle-dl
        git -C /var/lib/moodle-dl add .
        git -C /var/lib/moodle-dl commit -m "moodle-dl updated on `$(date)`"
      '';
      path = with pkgs; [
        openssh
        moodle-dl
        git
        coreutils
      ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
