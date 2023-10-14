{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.htop;
in {
  options.roles.htop = {
    enable = mkEnableOption "htop role";
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings =
        {
          "delay" = 10;
          ".tree_view_always_by_pid" = 1;
          "tree_view" = 1;
        }
        // (with config.lib.htop;
          leftMeters [
            (bar "LeftCPUs2")
            (bar "Memory")
            (bar "Swap")
          ])
        // (with config.lib.htop;
          rightMeters [
            (bar "RightCPUs2")
            (text "Tasks")
            (text "LoadAverage")
            (text "Uptime")
          ]);
    };
  };
}
