{inputs, ...}: {
  flake.modules.nixos.steam-deck = {...}: {
    imports = [
      inputs.jovian.nixosModules.jovian
    ];

    jovian = {
      devices.steamdeck = {
        enable = true;
        autoUpdate = true;
      };
      steam = {
        enable = true;
        autoStart = true;
        user = "scrumplex";
      };
      decky-loader.enable = true;
    };
  };
}
