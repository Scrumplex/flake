{
  lib,
  pkgs,
  ...
}: {
  systemd.user.services."lxqt-policykit-agent" = {
    description = "LXQt PolicyKit Agent";
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.lxqt.lxqt-policykit;
      Slice = ["background-graphical.slice"];
    };
  };

  hm.wayland.windowManager.sway.config.floating.criteria = [{app_id = "lxqt-policykit-agent";}];
}
