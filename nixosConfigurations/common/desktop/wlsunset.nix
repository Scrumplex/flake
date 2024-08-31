{...}: {
  hm.services.wlsunset = {
    enable = true;
    latitude = "51.6";
    longitude = "10.1";
    temperature.day = 5700;
    temperature.night = 3000;
  };
  hm.systemd.user.services."wlsunset" = {
    Unit.After = ["graphical-session.target"];
    Service.Slice = ["background-graphical.slice"];
  };
}
