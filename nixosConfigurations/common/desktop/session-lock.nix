{
  lib,
  pkgs,
  ...
}: {
  security.pam.services.gtklock = {};

  environment.systemPackages = with pkgs; [gtklock];

  hm.services.swayidle.events.lock = "${lib.getExe pkgs.gtklock} --daemonize";
}
