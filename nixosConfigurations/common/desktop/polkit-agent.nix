{
  lib,
  pkgs,
  ...
}: {
  systemd.user.services."lxqt-policykit-agent" = {
    description = "LXQt PolicyKit Agent";
    wantedBy = ["graphical-session.target"];
    serviceConfig.ExecStart = lib.getExe pkgs.lxqt.lxqt-policykit;
  };

  hm.wayland.windowManager.sway.config.floating.criteria = [{app_id = "lxqt-policykit-agent";}];
}
