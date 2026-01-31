{
  flake.modules.nixos."machine-galileo" = {
    services.home-assistant.config.sensor = [
      {
        platform = "linux_battery";
      }
    ];
  };
}
