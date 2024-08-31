{...}: {
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  hm.services.blueman-applet.enable = true;
  hm.systemd.user.services."blueman-applet" = {
    Unit.After = ["graphical-session.target"];
    Service.Slice = ["background-graphical.slice"];
  };

  boot.extraModprobeConfig = ''
    # Fix Nintendo Switch Pro Controller disconnects
    options bluetooth disable_ertm=1
  '';
}
