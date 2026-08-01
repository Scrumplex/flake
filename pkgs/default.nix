{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      channel-notifier = pkgs.python3.pkgs.callPackage ./channel-notifier {};

      ha-solarman = pkgs.home-assistant.python.pkgs.callPackage ./ha-solarman.nix {};
    };
  };
  flake.overlays.legacy = final: _: {
    channel-notifier = final.python3.pkgs.callPackage ./channel-notifier {};

    ha-solarman = final.home-assistant.python3Packages.callPackage ./ha-solarman.nix {};
  };
}
