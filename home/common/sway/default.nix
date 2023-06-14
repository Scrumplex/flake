{
  config,
  pkgs,
  ...
}: {
  imports = [./fuzzel.nix ./mako.nix ./swayidle.nix ./waybar ./wlogout.nix ./wlsunset.nix ./wob.nix];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = let
      wallpaper = pkgs.fetchurl {
        name = "sway-wallpaper.jpg";
        url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
        hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
      };
    in {
      terminal = "${pkgs.kitty}/bin/kitty";
      modifier = "Mod4";
      startup = [
        {
          command = "${pkgs.systemd}/bin/systemctl --user import-environment";
        } # ugly, but this fixes most issues, until home-manager adopts environment.d
      ];
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
      output = {
        "LG Electronics LG ULTRAGEAR 104MANJ7FL47" = {
          mode = "2560x1440@144Hz";
          position = "0,0";
          adaptive_sync = "on";
        };
        "Samsung Electric Company S24E650 H4ZJ803253" = {
          mode = "1920x1080@60Hz";
          position = "2560,0";
        };
        "BOE 0x095F Unknown" = {
          mode = "2256x1504@59.999Hz";
          position = "0,0";
          scale = "1.25";
        };
        "*" = {bg = "${wallpaper} fill";};
      };
      assigns = {
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
      floating.criteria = [{app_id = "lxqt-policykit-agent";}];
      window = {
        border = 4;
        hideEdgeBorders = "smart";
        commands = [
          {
            criteria.app_id = "popup_pulsemixer";
            command = "floating enable; sticky enable; resize set 800 600; border pixel";
          }
          {
            criteria = {
              app_id = "firefox";
              title = "Picture-in-Picture";
            };
            command = "floating enable; sticky enable";
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
      colors = with config.theme.colors; {
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
      keybindings = let
        swayConf = config.wayland.windowManager.sway.config;
        terminal = swayConf.terminal;
        menu = swayConf.menu;
        mod = swayConf.modifier;
        left = swayConf.left;
        right = swayConf.right;
        up = swayConf.up;
        down = swayConf.down;

        mpc = "${pkgs.mpc-cli}/bin/mpc";
        pamixer = "${pkgs.pamixer}/bin/pamixer";
        sed = "${pkgs.gnused}/bin/sed";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in {
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+Escape" = "kill";
        "${mod}+d" = "exec ${menu}";
        "${mod}+p" = "exec ${config.programs.password-store.package}/bin/passmenu";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec ${pkgs.wlogout}/bin/wlogout";
        "${mod}+Ctrl+q" = "exec ${pkgs.gtklock}/bin/gtklock -d";
        # TODO: Screenshots
        #"${mod}+Print" = "";
        "${mod}+Backspace" = "exec ${pkgs.mako}/bin/makoctl dismiss";
        "${mod}+r" = "mode resize";

        "${mod}+${left}" = "focus left";
        "${mod}+${right}" = "focus right";
        "${mod}+${up}" = "focus up";
        "${mod}+${down}" = "focus down";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Up" = "focus up";
        "${mod}+Down" = "focus down";

        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${right}" = "move right";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Down" = "move down";

        "${mod}+Ctrl+${left}" = "move workspace output left";
        "${mod}+Ctrl+${right}" = "move workspace output right";
        "${mod}+Ctrl+${up}" = "move workspace output up";
        "${mod}+Ctrl+${down}" = "move workspace output down";
        "${mod}+Ctrl+Left" = "move workspace output left";
        "${mod}+Ctrl+Right" = "move workspace output right";
        "${mod}+Ctrl+Up" = "move workspace output up";
        "${mod}+Ctrl+Down" = "move workspace output down";

        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4:mail";
        "${mod}+5" = "workspace 5:chat";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";

        "${mod}+Shift+1" = "move container to workspace 1";
        "${mod}+Shift+2" = "move container to workspace 2";
        "${mod}+Shift+3" = "move container to workspace 3";
        "${mod}+Shift+4" = "move container to workspace 4:mail";
        "${mod}+Shift+5" = "move container to workspace 5:chat";
        "${mod}+Shift+6" = "move container to workspace 6";
        "${mod}+Shift+7" = "move container to workspace 7";
        "${mod}+Shift+8" = "move container to workspace 8";
        "${mod}+Shift+9" = "move container to workspace 9";
        "${mod}+Shift+0" = "move container to workspace 0";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+f" = "fullscreen toggle global";

        "${mod}+Shift+Space" = "floating toggle";

        "${mod}+Space" = "focus mode_toggle";

        "${mod}+a" = "focus parent";

        "XF86AudioStop" = "exec ${mpc} stop";
        "XF86AudioPlay" = "exec ${mpc} toggle";
        "XF86AudioPause" = "exec ${mpc} toggle";
        "XF86AudioNext" = "exec ${mpc} next";
        "XF86AudioPrev" = "exec ${mpc} prev";

        "XF86AudioMute" = "exec ${pamixer} -t && ${pamixer} --get-volume > $XDG_RUNTIME_DIR/wob.sock";
        "XF86AudioRaiseVolume" = "exec ${pamixer} -ui 2 && ${pamixer} --get-volume > $XDG_RUNTIME_DIR/wob.sock";
        "XF86AudioLowerVolume" = "exec ${pamixer} -ud 2 && ${pamixer} --get-volume > $XDG_RUNTIME_DIR/wob.sock";

        "${mod}+XF86AudioMute" = "exec ${config.programs.waybar.settings.mainBar."custom/pa-mute".on-click}";
        "${mod}+m" = "exec ${config.programs.waybar.settings.mainBar."custom/pa-mute".on-click}";
        # TODO: make this nice
        "${mod}+n" =
          if config.programs.waybar.extraModules.cameraBlank.enable
          then "exec ${config.programs.waybar.extraModules.cameraBlank.onClickScript}"
          else "exec echo noop";

        "Shift+XF86AudioRaiseVolume" = "exec ${mpc} vol +2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
        "Shift+XF86AudioLowerVolume" = "exec ${mpc} vol -2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";

        "XF86MonBrightnessDown" = "exec ${brightnessctl} set 5%- | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $XDG_RUNTIME_DIR/wob.sock";
        "XF86MonBrightnessUp" = "exec ${brightnessctl} set 5%+ | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $XDG_RUNTIME_DIR/wob.sock";
      };
    };
    systemd.xdgAutostart = true;
  };

  home.packages = with pkgs; [wl-clipboard gtklock pulsemixer];
}
