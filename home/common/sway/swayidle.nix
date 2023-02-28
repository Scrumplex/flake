{pkgs, ...}: {
  services.swayidle = let
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    gtklock = "${pkgs.gtklock}/bin/gtklock -d";
    systemctl = "${pkgs.systemd}/bin/systemctl";
  in {
    enable = true;
    extraArgs = ["-d"];
    events = [
      {
        event = "before-sleep";
        command = "${gtklock}; ${swaymsg} 'output * power on'";
      }
      {
        event = "after-resume";
        command = "${swaymsg} 'output * power on'";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 600;
        command = "${systemctl} suspend";
      }
    ];
  };
}
