{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) map substring;
  inherit (lib.attrsets) getBin mapAttrsToList;
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;

  getExe' = x: y: "${getBin x}/bin/${y}";

  # create exec shortcut for Sway
  mkExec = keyCombo: exec: {${keyCombo} = "exec ${exec}";};

  # create move/focus shortcuts for Sway
  mkDirectionKeys = key: direction: {
    "${mod}+${key}" = "focus ${direction}";
    "${mod}+Shift+${key}" = "move ${direction}";
    "${mod}+Ctrl+${key}" = "move workspace output ${direction}";
  };

  # create move/focus workspace shortcuts for Sway
  mkWorkspaceKeys = workspace: let
    key = substring 0 1 workspace;
  in {
    "${mod}+${key}" = "workspace ${workspace}";
    "${mod}+Shift+${key}" = "move container to workspace ${workspace}";
  };

  swayConf = config.wayland.windowManager.sway.config;
  cameraBlankConf = config.programs.waybar.extraModules.cameraBlank;

  wobSock = "$XDG_RUNTIME_DIR/wob.sock";

  mod = swayConf.modifier;

  mpc = lib.getExe pkgs.mpc-cli;
  pamixer = lib.getExe pkgs.pamixer;
  sed = lib.getExe pkgs.gnused;
  brightnessctl = lib.getExe pkgs.brightnessctl;
in {
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
      output."*" = {bg = "${wallpaper} fill";};
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
      keybindings = lib.mkMerge (
        [
          (mkExec "${mod}+Return" swayConf.terminal)
          (mkExec "${mod}+d" swayConf.menu)
          (mkExec "${mod}+p" (getExe' config.programs.password-store.package "passmenu"))
          (mkExec "${mod}+period" "${getExe pkgs.bemoji} -t")
          (mkExec "${mod}+Shift+e" (getExe pkgs.wlogout))
          (mkExec "${mod}+Ctrl+q" "${getExe pkgs.gtklock} -d")
          (mkExec "${mod}+Backspace" "${getExe' pkgs.mako "makoctl"} dismiss")
          (mkExec "XF86AudioStop" "${mpc} stop")
          (mkExec "XF86AudioPlay" "${mpc} toggle")
          (mkExec "XF86AudioPause" "${mpc} toggle")
          (mkExec "XF86AudioNext" "${mpc} next")
          (mkExec "XF86AudioPrev" "${mpc} prev")
          (mkExec "XF86AudioMute" "${pamixer} -t && ${pamixer} --get-volume > ${wobSock}")
          (mkExec "XF86AudioRaiseVolume" "${pamixer} -ui 2 && ${pamixer} --get-volume > ${wobSock}")
          (mkExec "XF86AudioLowerVolume" "${pamixer} -ud 2 && ${pamixer} --get-volume > ${wobSock}")
          (mkExec "Shift+XF86AudioRaiseVolume" "${mpc} vol +2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > ${wobSock}")
          (mkExec "Shift+XF86AudioLowerVolume" "${mpc} vol -2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > ${wobSock}")
          (mkExec "XF86MonBrightnessDown" "${brightnessctl} set 5%- | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}")
          (mkExec "XF86MonBrightnessUp" "${brightnessctl} set 5%+ | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}")

          (mkExec "${mod}+m" config.programs.waybar.settings.mainBar."custom/pa-mute".on-click)
          (mkIf cameraBlankConf.enable (mkExec "${mod}+n" cameraBlankConf.onClickScript))
        ]
        ++ (
          map mkWorkspaceKeys ["1" "2" "3" "4:mail" "5:chat" "6" "7" "8" "9"]
        )
        ++ (
          mapAttrsToList mkDirectionKeys {
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
    systemd.xdgAutostart = true;
  };

  home.packages = with pkgs; [wl-clipboard gtklock pulsemixer];
}
