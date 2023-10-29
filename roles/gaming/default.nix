{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.gaming = {
    enable = mkEnableOption "gaming role";

    withGamemode = mkEnableOption "gamemode" // {default = true;};
  };
}
