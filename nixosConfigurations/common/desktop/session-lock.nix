{
  lib,
  pkgs,
  ...
}: {
  security.pam.services.gtklock = {};

  environment.systemPackages = with pkgs; [gtklock];

  hm.services.swayidle.events = [
    {
      event = "lock";
      command = "${lib.getExe pkgs.gtklock} --daemonize";
    }
  ];
}
