{ config, pkgs, ... }:

let
  downloads = "${config.home.homeDirectory}/Downloads";
in
{
  systemd.user.services.clean-downloads = {
    Unit = {
      Description = "Delete Downloads entries older than 30 days";
      ConditionPathIsDirectory = downloads;
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find ${downloads} -mindepth 1 -maxdepth 1 -mtime +30 -exec ${pkgs.coreutils}/bin/rm -rf {} +";
    };
  };

  systemd.user.timers.clean-downloads = {
    Unit.Description = "Weekly cleanup of Downloads";

    Timer = {
      OnCalendar = "weekly";
      Persistent = true; # catch up if the machine was off at the scheduled time
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
