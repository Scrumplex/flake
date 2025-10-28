{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets."wpa_supplicant.conf".file = ../../secrets/cosmos/wpa_supplicant.conf.age;

  networking = {
    interfaces.wlan0.useDHCP = true;
    wireless = {
      enable = true;
      secretsFile = config.age.secrets."wpa_supplicant.conf".path;
      networks."Beehive".pskRaw = "ext:psk_Beehive";
    };
  };

  systemd.network.networks."40-wlan0" = {
    dhcpV4Config.RouteMetric = 512;
    ipv6AcceptRAConfig.RouteMetric = 512;
  };

  systemd.services."disable-wifi-powersave" = {
    description = "Disable WiFi powersave";
    after = ["wpa_supplicant.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe pkgs.iw} dev wlan0 set power_save off";
    };
  };
}
