{...}: {
  services.upower.enable = true;

  hm.services.poweralertd.enable = true;
  hm.systemd.user.services."poweralertd" = {
    Unit.After = ["graphical-session.target"];
    Service.Slice = ["background-graphical.slice"];
  };
}
