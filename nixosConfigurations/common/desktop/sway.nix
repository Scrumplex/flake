{
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  inherit (lib) getExe mapAttrsToList singleton;
  inherit (lib'.sway) mkDirectionKeys mkExec mkWorkspaceKeys;

  wallpaper = pkgs.fetchurl {
    name = "sway-wallpaper.jpg";
    url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
    hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
  };
in {
  primaryUser.extraGroups = ["video" "input"];

  environment.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "NIXOS_OZONE_WL" = "1";
  };

  programs.sway = {
    enable = true;
    extraOptions = ["-Dlegacy-wl-drm"];
    wrapperFeatures.gtk = true;
    extraPackages = [];
  };

  hm.wayland.windowManager.sway = {
    enable = true;
    package = config.programs.sway.package;
    systemd.enable = false;
    config = {
      terminal = "uwsm app -T";
      modifier = "Mod4";
      startup = [
        {command = "uwsm finalize";}
      ];

      input."type:keyboard" = {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
        xkb_numlock = "enabled";
      };

      output."*" = {bg = "${wallpaper} fill";};
      assigns = {
        # TODO: other roles
        "4" = [{app_id = "evolution";}];
        "5" = [
          {class = "Signal";}
          {class = "Element";}
          {class = "discord";}
          {app_id = "org.telegram.desktop";}
          {app_id = "Element";}
          {app_id = "discord";}
        ];
      };

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
        swayConf = config.hm.wayland.windowManager.sway.config;
        # TODO; role
        wobSock = "$XDG_RUNTIME_DIR/wob.sock";

        mod = swayConf.modifier;

        mpc = getExe pkgs.mpc-cli;
        pamixer = getExe pkgs.pamixer;
        sed = getExe pkgs.gnused;
        brightnessctl = getExe pkgs.brightnessctl;
      in
        lib.mkMerge (
          [
            (mkExec "${mod}+Return" swayConf.terminal)
            (mkExec "${mod}+d" swayConf.menu)
            (mkExec "${mod}+Ctrl+q" "loginctl lock-session")
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
          ]
          ++ (
            map (mkWorkspaceKeys mod) ["1" "2" "3" "4" "5" "6" "7" "8" "9"]
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

            "${mod}+w" = "layout toggle tabbed split";
            "${mod}+e" = "layout toggle split";

            "${mod}+f" = "fullscreen toggle";
            "${mod}+Shift+f" = "fullscreen toggle global";

            "${mod}+Space" = "focus mode_toggle";
            "${mod}+Shift+Space" = "floating toggle";

            "${mod}+a" = "focus parent";
          })
        );
      colors = with config.hm.theme.colors; {
        focused = {
          background = "#${blue}";
          border = "#${blue}";
          childBorder = "#${blue}";
          indicator = "#${blue}";
          text = "#${base}";
        };
        focusedInactive = {
          background = "#${surface0}";
          border = "#${surface0}";
          childBorder = "#${surface0}";
          indicator = "#${surface0}";
          text = "#${pink}";
        };
        unfocused = {
          background = "#${base}";
          border = "#${base}";
          childBorder = "#${base}";
          indicator = "#${base}";
          text = "#${text}";
        };
        urgent = {
          background = "#${peach}";
          border = "#${peach}";
          childBorder = "#${peach}";
          indicator = "#${peach}";
          text = "#${base}";
        };
      };
    };
  };

  services.dbus.implementation = "broker";

  services.displayManager.enable = true;
  programs.uwsm = {
    enable = true;
    waylandCompositors.sway = {
      prettyName = "Sway";
      comment = "Sway with systemd";
      binPath = getExe config.hm.wayland.windowManager.sway.package;
    };
  };
  hm.xdg.configFile."uwsm/default-id".text = ''
    sway-uwsm.desktop
  '';

  hm.programs.fish.interactiveShellInit = lib.mkOrder 2000 ''
    test -n "$XDG_SESSION_TYPE" -a "$XDG_SESSION_TYPE" = "tty" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq 1; and uwsm check may-start; and begin
      exec systemd-cat -t uwsm-start uwsm start -S -F default
    end
  '';
}
