{
  config,
  lib,
  ...
}: {
  flake.modules.nixos.desktop = {
    users.users.${config.flake.meta.username}.extraGroups = ["video" "input"];

    environment.sessionVariables = {
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "NIXOS_OZONE_WL" = "1";
    };

    programs.niri.enable = true;
  };

  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    osConfig,
    ...
  }: let
    mkMoveFocusBinds' = key: direction: mkMoveFocusBinds key direction direction;
    mkMoveFocusBinds = key: moveDirection: focusDirection: {
      "Mod+${key}"."focus-${focusDirection}" = {};
      "Mod+Shift+${key}"."move-${moveDirection}" = {};
    };
    mkMoveWorkspaceBinds = key: direction: {
      "Mod+Ctrl+${key}"."move-workspace-to-monitor-${direction}" = {};
    };
    mkWorkspaceBinds = workspace: {
      "Mod+${toString workspace}".focus-workspace = workspace;
      "Mod+Shift+${toString workspace}".move-column-to-workspace = workspace;
    };
  in {
    wayland.windowManager.niri = {
      enable = true;
      inherit (osConfig.programs.niri) package;

      settings = {
        input = {
          keyboard = {
            numlock = true;
            xkb = {
              layout = "us";
              variant = "altgr-intl";
            };
          };
          focus-follows-mouse._props.max-scroll-amount = "10%";
        };

        layout = {
          gaps = 8;
          border.off = {};
          background-color = "#11111b";
          center-focused-column = "never";
          always-center-single-column = {};
          preset-column-widths._children = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
          ];
          default-column-width.proportion = 1. / 2.;
          focus-ring = {
            width = 4;
            active-color = "#7fc8ff";
            inactive-color = "#505050"; # TODO: catppuccin
          };
        };
        prefer-no-csd = {};

        _children = [
          {workspace._args = ["messages"];}
          {
            window-rule = {
              # No, this is not a DNS server configuration
              geometry-corner-radius._args = [8. 8. 8. 8.];
              clip-to-geometry = true;
            };
          }
          {
            window-rule = {
              _children = [
                {match._props.app-id = "org.gnome.Evolution";}
                {match._props.app-id = "Element";}
                {match._props.app-id = "discord";}
                {match._props.app-id = "org.telegram.desktop";}
                {match._props.app-id = "signal";}
                {exclude._props.at-startup = false;}
                {exclude._props.is-urgent = false;}
              ];
              open-on-workspace = "messages";
              open-focused = false;
            };
          }
          {
            window-rule = {
              _children = [
                {
                  match._props = {
                    app-id = "steam";
                    title = "^notificationtoasts_[0-9]+_desktop$";
                  };
                }
              ];
              default-floating-position._props = {
                relative-to = "bottom-right";
                x = 0;
                y = 0;
              };
              open-focused = false;
              focus-ring.off = {};
            };
          }
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        binds = lib.mkMerge [
          {
            "Mod+Shift+Slash".show-hotkey-overlay = {};

            "Mod+M" = {
              _props = {
                hotkey-overlay-title = "Mute Input";
                allow-when-locked = true;
              };
              spawn = [(lib.getExe config.programs.noctalia.package) "msg" "mic-mute"];
            };
            "XF86AudioMute" = {
              _props = {
                hotkey-overlay-title = "Mute Output";
                allow-when-locked = true;
              };
              spawn = [(lib.getExe config.programs.noctalia.package) "msg" "volume-mute"];
            };
            "XF86AudioLowerVolume" = {
              _props = {
                hotkey-overlay-title = "Output Volume -";
                allow-when-locked = true;
              };
              spawn = [(lib.getExe config.programs.noctalia.package) "msg" "volume-down"];
            };
            "XF86AudioRaiseVolume" = {
              _props = {
                hotkey-overlay-title = "Output Volume +";
                allow-when-locked = true;
              };
              spawn = [(lib.getExe config.programs.noctalia.package) "msg" "volume-up"];
            };
            "XF86MonBrightnessDown" = {
              _props = {
                hotkey-overlay-title = "Screen Brightness -";
                allow-when-locked = true;
              };
              spawn = [(lib.getExe config.programs.noctalia.package) "msg" "brightness-down"];
            };
            "XF86MonBrightnessUp" = {
              _props = {
                hotkey-overlay-title = "Screen Brightness +";
                allow-when-locked = true;
              };
              spawn = [(lib.getExe config.programs.noctalia.package) "msg" "brightness-up"];
            };
          }
          (mkMoveFocusBinds' "Left" "column-left")
          (mkMoveFocusBinds' "Down" "window-down")
          (mkMoveFocusBinds' "Up" "window-up")
          (mkMoveFocusBinds' "Right" "column-right")
          (mkMoveFocusBinds' "H" "column-left")
          (mkMoveFocusBinds' "J" "window-down")
          (mkMoveFocusBinds' "K" "window-up")
          (mkMoveFocusBinds' "L" "column-right")
          (mkMoveWorkspaceBinds "Left" "left")
          (mkMoveWorkspaceBinds "Down" "down")
          (mkMoveWorkspaceBinds "Up" "up")
          (mkMoveWorkspaceBinds "Right" "right")
          (mkMoveWorkspaceBinds "H" "left")
          (mkMoveWorkspaceBinds "J" "down")
          (mkMoveWorkspaceBinds "K" "up")
          (mkMoveWorkspaceBinds "L" "right")
          (mkMoveFocusBinds' "Page_Down" "workspace-down")
          (mkMoveFocusBinds' "Page_Up" "workspace-up")
          (mkMoveFocusBinds' "U" "workspace-down")
          (mkMoveFocusBinds' "I" "workspace-up")
          (mkMoveFocusBinds "Home" "column-to-first" "column-first")
          (mkMoveFocusBinds "End" "column-to-last" "column-last")
          {
            "Mod+WheelScrollDown" = {
              _props.cooldown-ms = 150;
              focus-workspace-down = {};
            };
            "Mod+WheelScrollUp" = {
              _props.cooldown-ms = 150;
              focus-workspace-up = {};
            };
          }
          {
            "Mod+Tab".focus-monitor-next = {};
            "Mod+Shift+Tab".move-column-to-monitor-next = {};
            "Mod+Ctrl+Tab".move-workspace-to-monitor-next = {};
          }
          (mkMoveFocusBinds' "WheelScrollLeft" "column-left")
          (mkMoveFocusBinds' "WheelScrollRight" "column-right")
          (mkWorkspaceBinds 1)
          (mkWorkspaceBinds 2)
          (mkWorkspaceBinds 3)
          (mkWorkspaceBinds 4)
          (mkWorkspaceBinds 5)
          (mkWorkspaceBinds 6)
          (mkWorkspaceBinds 7)
          (mkWorkspaceBinds 8)
          (mkWorkspaceBinds 9)
          {
            "Mod+BracketLeft".consume-or-expel-window-left = {};
            "Mod+BracketRight".consume-or-expel-window-right = {};
            "Mod+Comma".consume-window-into-column = {};
            "Mod+Period".expel-window-from-column = {};
          }
          {
            "Mod+O" = {
              _props.repeat = false;
              toggle-overview = {};
            };
            "Mod+Escape".close-window = {};
            "Mod+R".switch-preset-column-width = {};
            "Mod+Shift+R".switch-preset-window-height = {};
            "Mod+Ctrl+R".reset-window-height = {};
            "Mod+W".maximize-column = {};
            "Mod+F".fullscreen-window = {};
            "Mod+Shift+F".expand-column-to-available-width = {};
            "Mod+E".toggle-column-tabbed-display = {};
            "Mod+C".center-column = {};
            "Mod+Ctrl+C".center-visible-columns = {};
            "Mod+Space".switch-focus-between-floating-and-tiling = {};
            "Mod+Shift+Space".toggle-window-floating = {};
          }
          {
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";
          }
        ];
      };
    };
  };
}
