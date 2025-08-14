{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    name = "sway-wallpaper.jpg";
    url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
    hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
  };

  mkMoveFocusBinds' = key: direction: mkMoveFocusBinds key direction direction;
  mkMoveFocusBinds = key: moveDirection: focusDirection: {
    "Mod+${key}".action = config.hm.lib.niri.actions."focus-${focusDirection}";
    "Mod+Shift+${key}".action = config.hm.lib.niri.actions."move-${moveDirection}";
  };
  mkMoveWorkspaceBinds = key: direction: {
    "Mod+Ctrl+${key}".action = config.hm.lib.niri.actions."move-workspace-to-monitor-${direction}";
  };
  mkWorkspaceBinds = workspace: {
    "Mod+${toString workspace}".action = config.hm.lib.niri.actions.focus-workspace workspace;
    "Mod+Shift+${toString workspace}".action = inputs.niri.lib.kdl.magic-leaf "move-column-to-workspace" workspace;
  };
in {
  hm.imports = [inputs.niri.homeModules.config];
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  hm.programs.niri = {
    package = config.programs.niri.package;
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
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
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
          open-on-workspace = "messages";
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
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
      ];
      binds = with config.hm.lib.niri.actions;
        lib.mkMerge [
          {
            "Mod+Shift+Slash".action = show-hotkey-overlay;
            "Mod+Shift+E".action = quit;
            "Mod+Return" = {
              hotkey-overlay.title = "Open a terminal";
              action = spawn ["kitty"];
            };
            "Mod+D" = {
              hotkey-overlay.title = "Open launcher";
              action = spawn ["fuzzel"];
            };
            "Mod+Ctrl+Q" = {
              hotkey-overlay.title = "Lock the session";
              action = spawn ["loginctl" "lock-session"];
            };
            "Mod+Backspace".action = spawn ["makoctl" "dismiss"];

            "XF86AudioMute" = {
              allow-when-locked = true;
              action = spawn ["pamixer" "-t"];
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action = spawn ["pamixer" "-ud" "2"];
            };
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action = spawn ["pamixer" "-ui" "2"];
            };
            "XF86AudioStop" = {
              allow-when-locked = true;
              action = spawn ["mpc" "stop"];
            };
            "XF86AudioPlay" = {
              allow-when-locked = true;
              action = spawn ["mpc" "toggle"];
            };
            "XF86AudioPause" = {
              allow-when-locked = true;
              action = spawn ["mpc" "toggle"];
            };
            "XF86AudioPrev" = {
              allow-when-locked = true;
              action = spawn ["mpc" "prev"];
            };
            "XF86AudioNext" = {
              allow-when-locked = true;
              action = spawn ["mpc" "next"];
            };
            "Shift+XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action = spawn ["mpc" "volume" "-2"];
            };
            "Shift+XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action = spawn ["mpc" "volume" "+2"];
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action = spawn ["brightnessctl" "set" "5%-"];
            };
            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action = spawn ["brightnessctl" "set" "5%+"];
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
            "Mod+Space".action = toggle-window-floating;
            "Mod+Shift+Space".action = switch-focus-between-floating-and-tiling;
          }
          {
            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";
            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";
          }
          {
            "Print".action = screenshot;
            "Shift+Print".action = screenshot-window;
            "Mod+Print".action = inputs.niri.lib.kdl.magic-leaf "screenshot-screen";
          }
        ];
    };
  };

  environment.systemPackages = with pkgs; [xwayland-satellite mpc brightnessctl pamixer];

  hm.programs.fish.interactiveShellInit = lib.mkOrder 2000 ''
    test -n "$XDG_SESSION_TYPE" -a "$XDG_SESSION_TYPE" = "tty" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq 1; and begin
      exec systemd-cat -t niri-startup niri-session
    end
  '';

  systemd.user.services."swaybg" = {
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    requisite = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${wallpaper}";
      Restart = "on-failure";
    };
  };
}
