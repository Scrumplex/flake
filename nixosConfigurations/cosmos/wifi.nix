{config, ...}: {
  age.secrets."wpa_supplicant.conf" = {
    file = ../../secrets/cosmos/wpa_supplicant.conf.age;
    owner = "wpa_supplicant";
    group = "wpa_supplicant";
  };

  networking.wireless = {
    enable = true;
    secretsFile = config.age.secrets."wpa_supplicant.conf".path;
    networks."Beehive".pskRaw = "ext:psk_Beehive";
  };

  systemd.network.networks."30-wlp1s0u1" = {
    name = "wlp1s0u1";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = "kernel";
    };
    dhcpV4Config.RouteMetric = 512;
    ipv6AcceptRAConfig.RouteMetric = 512;
  };

  boot.blacklistedKernelModules = [
    "brcmfmac" # We don't want onboard wifi
  ];
}
