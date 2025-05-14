{
  lib,
  pkgs,
  ...
}: {
  services.pipewire = {
    enable = true;
    systemWide = true;
    pulse.enable = true;
  };

  systemd.services."snapclient" = {
    description = "SnapCast client";
    wantedBy = ["multi-user.target"];
    after = [
      "network.target"
      "nss-lookup.target"
      "pipewire.socket"
    ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --daemon --host cosmos.lan --player pulse";
      DynamicUser = true;
      SupplementaryGroups = ["pipewire"];
      RuntimeDirectory = "snapclient";
      PIDFile = "/var/run/snapclient/pid";
    };
  };
}
