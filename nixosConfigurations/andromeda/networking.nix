{...}: {
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };
  systemd.network.networks."50-en" = {
    name = "en*";
    DHCP = "ipv4";
    networkConfig = {
      IPv6PrivacyExtensions = "kernel";
      MulticastDNS = true;
    };
  };

  services.avahi.enable = false;

  # allow mdns
  networking.firewall.allowedUDPPorts = [5353];
}
