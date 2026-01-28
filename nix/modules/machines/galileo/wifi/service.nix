{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    age.secrets."Beehive.psk".file = ./Beehive.psk.age;

    networking.wireless.iwd = {
      enable = true;
    };

    systemd.network.networks."40-wl" = {
      name = "wl*";
      DHCP = "ipv4";
      networkConfig = {
        IPv6PrivacyExtensions = "kernel";
      };
    };

    systemd.tmpfiles.settings."40-iwd-Beehive"."/var/lib/iwd/Beehive.psk"."L".argument = config.age.secrets."Beehive.psk".path;
  };
}
