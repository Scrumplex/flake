{
  config,
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    imports = [inputs.niri.nixosModules.niri];
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    # we use lxqt pk agent
    systemd.user.services.niri-flake-polkit.enable = false;

    users.users.${config.flake.meta.username}.extraGroups = ["video" "input"];

    environment.sessionVariables = {
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "NIXOS_OZONE_WL" = "1";
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };

  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    ...
  }: let
    mkMoveFocusBinds' = key: direction: mkMoveFocusBinds key direction direction;
    mkMoveFocusBinds = key: moveDirection: focusDirection: {
      "Mod+${key}".action = config.lib.niri.actions."focus-${focusDirection}";
      "Mod+Shift+${key}".action = config.lib.niri.actions."move-${moveDirection}";
    };
    mkMoveWorkspaceBinds = key: direction: {
      "Mod+Ctrl+${key}".action = config.lib.niri.actions."move-workspace-to-monitor-${direction}";
    };
    mkWorkspaceBinds = workspace: {
      "Mod+${toString workspace}".action = config.lib.niri.actions.focus-workspace workspace;
      "Mod+Shift+${toString workspace}".action = inputs.niri.lib.kdl.magic-leaf "move-column-to-workspace" workspace;
    };
  in {
    programs.niri = {
      settings = {
        input = {
          keyboard = {
            numlock = true;
            xkb = {
              layout = "us";
              variant = "altgr-intl";
            };
          };
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "10%";
          };
        };

        layout = {
          gaps = 8;
          center-focused-column = "never";
          always-center-single-column = true;
          preset-column-widths = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
          ];
          default-column-width.proportion = 1. / 2.;
          focus-ring = {
            width = 4;
            active.color = "#7fc8ff";
            inactive.color = "#505050"; # TODO: catppuccin
          };
        };
        prefer-no-csd = true;
        workspaces."messages" = {};

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite-unstable;

        window-rules = [
          {
            matches = [
              {app-id = "org.gnome.Evolution";}
              {app-id = "Element";}
              {app-id = "discord";}
              {app-id = "org.telegram.desktop";}
              {app-id = "signal";}
            ];
            excludes = [
              {at-startup = false;}
              {is-urgent = false;}
            ];
            open-on-workspace = "messages";
            open-focused = false;
          }
          {
            geometry-corner-radius = {
              bottom-left = 8.;
              bottom-right = 8.;
              top-left = 8.;
              top-right = 8.;
            };
            clip-to-geometry = true;
          }
          {
            matches = [
              {
                app-id = "steam";
                title = "^notificationtoasts_[0-9]+_desktop$";
              }
            ];
            default-floating-position = {
              x = 0;
              y = 0;
              relative-to = "bottom-right";
            };
            open-focused = false;
            focus-ring.enable = false;
          }
        ];
        binds = with config.lib.niri.actions;
          lib.mkMerge [
            {
              "Mod+Shift+Slash".action = show-hotkey-overlay;
              "Mod+Ctrl+Q" = {
                hotkey-overlay.title = "Lock the session";
                action = spawn ["loginctl" "lock-session"];
              };

              "XF86AudioMute" = {
                allow-when-locked = true;
                action = spawn ["wob-volume" "toggle-mute"];
              };
              "XF86AudioLowerVolume" = {
                allow-when-locked = true;
                action = spawn ["wob-volume" "decrease-volume"];
              };
              "XF86AudioRaiseVolume" = {
                allow-when-locked = true;
                action = spawn ["wob-volume" "increase-volume"];
              };
              "XF86MonBrightnessDown" = {
                allow-when-locked = true;
                action = spawn ["wob-brightness" "decrease-brightness"];
              };
              "XF86MonBrightnessUp" = {
                allow-when-locked = true;
                action = spawn ["wob-brightness" "increase-brightness"];
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
                cooldown-ms = 150;
                action = focus-workspace-down;
              };
              "Mod+WheelScrollUp" = {
                cooldown-ms = 150;
                action = focus-workspace-up;
              };
            }
            {
              "Mod+Tab".action = focus-monitor-next;
              "Mod+Shift+Tab".action = move-column-to-monitor-next;
              "Mod+Ctrl+Tab".action = move-workspace-to-monitor-next;
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
              "Mod+BracketLeft".action = consume-or-expel-window-left;
              "Mod+BracketRight".action = consume-or-expel-window-right;
              "Mod+Comma".action = consume-window-into-column;
              "Mod+Period".action = expel-window-from-column;
            }
            {
              "Mod+O" = {
                repeat = false;
                action = toggle-overview;
              };
              "Mod+Escape".action = close-window;
              "Mod+R".action = switch-preset-column-width;
              "Mod+Shift+R".action = switch-preset-window-height;
              "Mod+Ctrl+R".action = reset-window-height;
              "Mod+W".action = maximize-column;
              "Mod+F".action = fullscreen-window;
              "Mod+Shift+F".action = expand-column-to-available-width;
              "Mod+E".action = toggle-column-tabbed-display;
              "Mod+C".action = center-column;
              "Mod+Ctrl+C".action = center-visible-columns;
              "Mod+Space".action = switch-focus-between-floating-and-tiling;
              "Mod+Shift+Space".action = toggle-window-floating;
            }
            {
              "Mod+Minus".action = set-column-width "-10%";
              "Mod+Equal".action = set-column-width "+10%";
              "Mod+Shift+Minus".action = set-window-height "-10%";
              "Mod+Shift+Equal".action = set-window-height "+10%";
            }
          ];
      };
    };
  };
}
