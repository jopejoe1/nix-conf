{ pkgs, ... }:

{
  systemd.timers."repo-sync" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "15m";
      Unit = "repo-sync.service";
    };
  };

  systemd.services."repo-sync" = {
    script = ''
      ${pkgs.git}/bin/git clone git@codeberg.org:jopejoe1/nix-conf.git /var/lib/repo-sync
      ${pkgs.git}/bin/git -C /var/lib/repo-sync remote add github git@github.com:jopejoe1/nix-conf.git
      ${pkgs.git}/bin/git -C /var/lib/repo-sync remote add gitlab git@gitlab.com:jopejoe1/nix-conf.git
      ${pkgs.git}/bin/git -C /var/lib/repo-sync pull -r github main
      ${pkgs.git}/bin/git -C /var/lib/repo-sync pull -r gitlab main
      ${pkgs.git}/bin/git -C /var/lib/repo-sync push origin
      ${pkgs.git}/bin/git -C /var/lib/repo-sync push github
      ${pkgs.git}/bin/git -C /var/lib/repo-sync push gitlab
      ${pkgs.coreutils}/bin/rm -r /var/lib/repo-sync
    '';
    path = [pkgs.openssh];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
