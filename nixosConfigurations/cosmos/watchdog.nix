{pkgs, ...}: {
  systemd.services."ping-watchdog" = {
    description = "Watchdog checking for network access";
    onFailure = ["reboot.target"];
    path = [pkgs.iputils];

    script = ''
      ping -c 4 -W 1 10.0.0.1
    '';
  };

  systemd.timers."ping-watchdog" = {
    after = ["network.target"];
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "minutely";
      OnActiveSec = "2m";
    };
  };
}
