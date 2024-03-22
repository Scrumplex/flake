{config, ...}: {
  age.secrets."mqtt-password".file = ../../secrets/common/mqtt-password.age;
  services.mosquitto = {
    enable = true;
    logType = ["all"];
    listeners = [
      {
        users.user = {
          passwordFile = config.age.secrets."mqtt-password".path;
          acl = [
            "readwrite homeassistant/#"
            "readwrite frigate/#"
          ];
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [1883];
}
