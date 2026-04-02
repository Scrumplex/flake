{
  flake.modules.nixos."desktop" = {
    networking.firewall.allowedUDPPorts = [
      6002
    ];

    services.pipewire.extraConfig.pipewire."90-raop-discover" = {
      "context.modules" = [
        {
          name = "libpipewire-module-raop-discover";
        }
      ];
    };
  };
}
