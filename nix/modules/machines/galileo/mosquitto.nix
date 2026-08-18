{lib, ...}: {
  flake.modules.nixos."machine-galileo" = {
    config,
    options,
    ...
  }: {
    options.services.mosquitto.defaultListener = lib.mkOption {
      type = options.services.mosquitto.listeners.type.nestedTypes.elemType;
      default = {};
    };

    config = {
      services.mosquitto = {
        enable = true;
        logType = ["all"];

        listeners = lib.mkIf (config.services.mosquitto.defaultListener != {}) [
          config.services.mosquitto.defaultListener
        ];
      };

      networking.firewall.allowedTCPPorts = [1883];
    };
  };
}
