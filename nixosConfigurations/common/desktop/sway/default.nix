{
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkIf;
  inherit (lib'.scrumplex.sway) mkExec;
in {
  hm.wayland.windowManager.sway = {
    enable = true;
    package = config.programs.sway.package;
    systemd.xdgAutostart = true;
    config = {
      startup = [{command = "${getExe' config.systemd.package "systemctl"} --user import-environment";}];

      input = {
        "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };

      # TODO: polkit role
      floating.criteria = [{app_id = "lxqt-policykit-agent";}];

      window = {
        border = 4;
        hideEdgeBorders = "smart";
        commands = [
          # TODO: other roles
          {
            criteria.app_id = "net.sapples.LiveCaptions";
            command = "floating enable; sticky enable";
          }
          {
            criteria.title = ".*";
            command = "inhibit_idle fullscreen";
          }
        ];
      };

      keybindings = let
        swayConf = config.hm.wayland.windowManager.sway.config;
        waybarExtraConf = config.hm.programs.waybar.extraModules;

        mod = swayConf.modifier;
      in
        lib.mkMerge [
          # TODO: role
          (mkExec "${mod}+p" (getExe' config.hm.programs.password-store.package "passmenu"))
          # TODO: role
          (mkExec "${mod}+c" "${getExe pkgs.hyprpicker} --autocopy")
          # TODO: role
          (mkExec "${mod}+period" "${getExe pkgs.bemoji} -t")

          # TODO: role
          (mkIf waybarExtraConf.cameraBlank.enable (mkExec "${mod}+n" waybarExtraConf.cameraBlank.onClickScript))
          (mkIf waybarExtraConf.paMute.enable (mkExec "${mod}+m" waybarExtraConf.paMute.onClickScript))
        ];
    };
  };
}
