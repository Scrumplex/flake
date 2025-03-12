{lib, ...}: let
  useDHCP = true;
in {
  systemd.network = {
    netdevs.br-lan.netdevConfig = {
      Name = "br-lan";
      Kind = "bridge";
    };

    networks = {
      lan-ports = {
        matchConfig.Name = "lan*";
        networkConfig.Bridge = "br-lan";
      };

      downstream = {
        name = "br-lan";

        linkConfig.RequiredForOnline = false;

        networkConfig = lib.mkMerge [
          (lib.mkIf (!useDHCP) {
            Address = "10.0.0.1/16";
            ConfigureWithoutCarrier = true;
          })
          (lib.mkIf useDHCP {
            DHCP = "yes";
            IPv6PrivacyExtensions = "kernel";
          })
        ];
      };
    };
  };
}
