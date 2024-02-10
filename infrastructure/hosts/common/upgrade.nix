{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.common.upgrade;
in {
  options.common.upgrade = {
    enable =
      mkEnableOption "automatic system upgrade"
      // mkOption {
        default = true;
      };

    flakeUrl = mkOption {
      type = types.str;
      description = "URL of flake containing NixOS configurations";
      default = "git+https://codeberg.org/Scrumplex/infrastructure.git";
    };

    flakeConfiguration = mkOption {
      type = types.str;
      description = "Name of flake nixosConfigurations key";
      default = config.networking.hostName;
      defaultText = "config.networking.hostName";
      example = "foobar";
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = "${cfg.flakeUrl}#${cfg.flakeConfiguration}";
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
    };
  };
}
