{
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkAliasOptionModule mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib'.scrumplex.sway) mkDirectionKeys mkExec mkWorkspaceKeys;

  cfg = config.roles.sway;
in {
  options.roles.sway = {
    enable = mkEnableOption "sway role";

    wallpaper = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Wallpaper used for all outputs
      '';
    };
  };

  imports = [
    (mkAliasOptionModule ["roles" "sway" "config"] ["hm" "wayland" "windowManager" "sway" "config"])
  ];

  config = mkIf cfg.enable {
    roles.base.user.extraGroups = ["video" "input"];
    roles.gtklock.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    hm.wayland.windowManager.sway = {
      enable = true;
      package = config.programs.sway.package;
      systemd.xdgAutostart = true;
    };

    roles.sway.config = {
      modifier = "Mod4";
      # ugly, but this fixes most issues, until home-manager adopts environment.d
      startup = [{command = "${pkgs.systemd}/bin/systemctl --user import-environment";}];

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
          xkb_numlock = "enabled";
        };
        "1133:49277:Logitech_Gaming_Mouse_G502" = {
          accel_profile = "adaptive";
          pointer_accel = "-1.0";
        };
        "1008:2967:HP,_Inc_HyperX_Pulsefire_Haste_2" = {
          accel_profile = "adaptive";
          pointer_accel = "-1.0";
        };
        "6127:24717:PixArt_Lenovo_USB_Optical_Mouse" = {
          accel_profile = "adaptive";
          pointer_accel = "-1.0";
        };
        "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };

      output."*" = {bg = "${cfg.wallpaper} fill";};
      assigns = {
        # TODO: other roles
        "4:mail" = [{app_id = "evolution";}];
        "5:chat" = [
          {class = "Signal";}
          {class = "Element";}
          {class = "discord";}
          {app_id = "org.telegram.desktop";}
          {app_id = "Element";}
          {app_id = "discord";}
        ];
      };

      # TODO: polkit role
      floating.criteria = [{app_id = "lxqt-policykit-agent";}];

      window = {
        border = 4;
        hideEdgeBorders = "smart";
        commands = [
          # TODO: other roles
          {
            criteria.app_id = "popup_pulsemixer";
            command = "floating enable; sticky enable; resize set 800 600; border pixel";
          }
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

      bars = [];

      fonts = {
        names = ["Monocraft"];
        size = 10.0;
      };

      keybindings = let
        swayConf = config.roles.sway.config;
        waybarExtraConf = config.hm.programs.waybar.extraModules;

        # TODO; role
        wobSock = "$XDG_RUNTIME_DIR/wob.sock";

        mod = swayConf.modifier;

        mpc = lib.getExe pkgs.mpc-cli;
        pamixer = lib.getExe pkgs.pamixer;
        sed = lib.getExe pkgs.gnused;
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in
        lib.mkMerge (
          [
            (mkExec "${mod}+Return" swayConf.terminal)
            (mkExec "${mod}+d" swayConf.menu)
            # TODO: role
            (mkExec "${mod}+p" (getExe' config.hm.programs.password-store.package "passmenu"))
            # TODO: role
            (mkExec "${mod}+period" "${getExe pkgs.bemoji} -t")
            # TODO: role
            (mkExec "${mod}+Shift+e" (getExe pkgs.wlogout))
            # TODO: role
            (mkExec "${mod}+Backspace" "${getExe' pkgs.mako "makoctl"} dismiss")
            # TODO: role
            (mkExec "XF86AudioStop" "${mpc} stop")
            (mkExec "XF86AudioPlay" "${mpc} toggle")
            (mkExec "XF86AudioPause" "${mpc} toggle")
            (mkExec "XF86AudioNext" "${mpc} next")
            (mkExec "XF86AudioPrev" "${mpc} prev")
            # TODO: role
            (mkExec "XF86AudioMute" "${pamixer} -t && ${pamixer} --get-volume > ${wobSock}")
            (mkExec "XF86AudioRaiseVolume" "${pamixer} -ui 2 && ${pamixer} --get-volume > ${wobSock}")
            (mkExec "XF86AudioLowerVolume" "${pamixer} -ud 2 && ${pamixer} --get-volume > ${wobSock}")
            # TODO: role
            (mkExec "Shift+XF86AudioRaiseVolume" "${mpc} vol +2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > ${wobSock}")
            (mkExec "Shift+XF86AudioLowerVolume" "${mpc} vol -2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > ${wobSock}")
            # TODO: role
            (mkExec "XF86MonBrightnessDown" "${brightnessctl} set 5%- | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}")
            (mkExec "XF86MonBrightnessUp" "${brightnessctl} set 5%+ | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}")

            # TODO: role
            (mkIf waybarExtraConf.cameraBlank.enable (mkExec "${mod}+n" waybarExtraConf.cameraBlank.onClickScript))
            (mkIf waybarExtraConf.paMute.enable (mkExec "${mod}+m" waybarExtraConf.paMute.onClickScript))
          ]
          ++ (
            map (mkWorkspaceKeys mod) ["1" "2" "3" "4:mail" "5:chat" "6" "7" "8" "9"]
          )
          ++ (
            mapAttrsToList (mkDirectionKeys mod) {
              ${swayConf.left} = "left";
              ${swayConf.right} = "right";
              ${swayConf.up} = "up";
              ${swayConf.down} = "down";
              "Left" = "left";
              "Right" = "right";
              "Up" = "up";
              "Down" = "down";
            }
          )
          ++ (singleton {
            "${mod}+Escape" = "kill";
            "${mod}+Shift+c" = "reload";
            "${mod}+r" = "mode resize";

            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            "${mod}+f" = "fullscreen toggle";
            "${mod}+Shift+f" = "fullscreen toggle global";

            "${mod}+Space" = "focus mode_toggle";
            "${mod}+Shift+Space" = "floating toggle";

            "${mod}+a" = "focus parent";
          })
        );
    };
  };
}
