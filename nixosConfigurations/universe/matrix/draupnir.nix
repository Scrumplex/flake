{
  config,
  pkgs,
  ...
}: {
  age.secrets."draupnir-access-token".file = ./draupnir-access-token.age;

  services.draupnir = {
    enable = true;
    package = pkgs.draupnir.override {nodejs = pkgs.nodejs_22;};

    secrets.accessToken = config.age.secrets."draupnir-access-token".path;

    settings = {
      homeserverUrl = "https://quack.duckhub.io";
      rawHomeserverUrl = config.services.draupnir.settings.homeserverUrl;
      managementRoom = "!LBLXgutvZVxFOJYksY:duckhub.io";
    };
  };
}
