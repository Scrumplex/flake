{
  config,
  lib,
  pkgs,
  utils,
  ...
}: let
  authSettings = {
    enableRecommendedPairwiseCiphers = true;
    wpaPasswordFile = config.age.secrets."wifi-password".path;
    saePasswordsFile = config.age.secrets."wifi-password".path;
  };

  bssSettings = {
    # enable 4addr mode and join the bridge
    wds_sta = 1;
    bridge = "br-lan";

    # Indoor environment only
    country3 = "0x49";

    # Stationary AP config indicates that the AP doesn't move hence location data
    # can be considered as always up to date. If configured, LCI data will be sent
    # as a radio measurement even if the request doesn't contain a max age element
    # that allows sending of such data. Default: 0.
    stationary_ap = 1;

    # okc: Opportunistic Key Caching (aka Proactive Key Caching)
    # Allow PMK cache to be shared opportunistically among configured interfaces
    # and BSSes (i.e., all configurations within a single hostapd process).
    okc = 1;
  };

  countryCode = "DE";
in {
  age.secrets."wifi-password".file = ../../secrets/centauri/wifi-password.age;

  hardware.wirelessRegulatoryDatabase = true;
  environment.systemPackages = [pkgs.iw];

  systemd = {
    services.hostapd = {
      # don't take down the network
      reloadIfChanged = true;

      unitConfig = rec {
        # needs to be here to remove the dependencies on individual interfaces,
        # because those are now vifs
        After = lib.mkForce [(utils.escapeSystemdPath "/sys/devices/virtual/net/br-lan.device")];
        Wants = After;
        BindsTo = lib.mkForce [];
      };
    };

    network.netdevs = let
      mkNetdev = name: {
        netdevConfig = {
          Name = name;
          Kind = "wlan";
        };
        wlanConfig = {
          PhysicalDevice = 0;
          Type = "ap";
        };
      };
    in {
      wl24g = mkNetdev "wl24g";
      wl5g = mkNetdev "wl5g";
      wl6g = mkNetdev "wl6g";
    };
  };

  services.hostapd = {
    enable = true;

    radios = {
      wl24g = {
        band = "2g";
        channel = 0;
        inherit countryCode;

        wifi4 = {
          enable = true;
          capabilities = [
            "LDPC"
            "HT40+"
            "GF"
            "SHORT-GI-20"
            "SHORT-GI-40"
            "TX-STBC"
            "RX-STBC1"
            "MAX-AMSDU-7935"
          ];
        };

        wifi6 = {
          enable = true;
          singleUserBeamformee = true;
          singleUserBeamformer = true;
          multiUserBeamformer = true;
        };

        wifi7 = {
          enable = true;
          singleUserBeamformee = true;
          singleUserBeamformer = true;
          multiUserBeamformer = true;
        };

        networks.wl24g = {
          ssid = "Banana";
          bssid = "E0:31:9E:3C:ED:3B";
          authentication = lib.mkMerge [
            authSettings
            {
              mode = "wpa2-sha1";
            }
          ];

          settings = lib.mkMerge [
            bssSettings
            {
              ieee80211w = 0;
            }
          ];
        };
      };

      wl5g = {
        band = "5g";
        channel = 0;
        inherit countryCode;

        wifi4 = {
          enable = true;
          capabilities = [
            "LDPC"
            "HT40+"
            "GF"
            "SHORT-GI-20"
            "SHORT-GI-40"
            "TX-STBC"
            "RX-STBC1"
            "MAX-AMSDU-7935"
          ];
        };

        wifi5 = {
          enable = true;
          operatingChannelWidth = "160";
          capabilities = [
            "MAX-MPDU-11454"
            "MAX-A-MPDU-LEN-EXP7"
            "VHT160"
            "RXLDPC"
            "SHORT-GI-80"
            "SHORT-GI-160"
            "TX-STBC-2BY1"
            "RX-STBC-1"
            "SU-BEAMFORMER"
            "SU-BEAMFORMEE"
            "MU-BEAMFORMER"
            "MU-BEAMFORMEE"
            "RX-ANTENNA-PATTERN"
            "TX-ANTENNA-PATTERN"
            "SOUDING-DIMENSION-2"
            "BF-ANTENNA-3"
          ];
        };

        wifi6 = {
          enable = true;
          operatingChannelWidth = "160";
          singleUserBeamformee = true;
          singleUserBeamformer = true;
          multiUserBeamformer = true;
        };

        wifi7 = {
          enable = true;
          operatingChannelWidth = "160";
          singleUserBeamformee = true;
          singleUserBeamformer = true;
          multiUserBeamformer = true;
        };

        networks.wl5g = {
          ssid = "Banana";
          bssid = "E0:31:9E:3C:ED:3C";
          authentication = lib.mkMerge [
            authSettings
            {
              mode = "wpa3-sae-transition";
            }
          ];
          settings = lib.mkMerge [
            bssSettings
          ];
        };
      };
    };
  };
}
