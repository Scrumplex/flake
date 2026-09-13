{
  flake.modules.nixos."machine-galileo" = {
    services.home-assistant.extraComponents = [
      "matter"
      "thread"
    ];

    services.matterjs-server.enable = true;
  };
}
