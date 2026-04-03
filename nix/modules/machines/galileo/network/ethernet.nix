{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    systemd.network.networks."40-en" = {
      name = "en*";
      DHCP = "ipv4";
      networkConfig = {
        IPv6PrivacyExtensions = "kernel";
      };
      dhcpV4Config.RouteMetric = 512;
      ipv6AcceptRAConfig.RouteMetric = 512;
    };
  };
}
