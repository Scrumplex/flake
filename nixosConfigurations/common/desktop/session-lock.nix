{
  lib,
  pkgs,
  ...
}: {
  security.pam.services.waylock = {};

  environment.systemPackages = with pkgs; [waylock];

  hm.services.swayidle.events = [
    {
      event = "lock";
      command = "${lib.getExe pkgs.waylock} -fork-on-lock";
    }
  ];
}
