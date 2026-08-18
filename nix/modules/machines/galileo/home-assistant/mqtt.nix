{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    age.secrets."hass-mqtt-password".file = ./mqtt-password.age;

    services.home-assistant.extraComponents = [
      "mqtt"
    ];

    services.mosquitto.defaultListener.users."hass" = {
      passwordFile = config.age.secrets."hass-mqtt-password".path;
      acl = [
        "readwrite homeassistant/#"
        "readwrite frigate/#"
      ];
    };

    # TODO: declarative home assistant config
  };
}
