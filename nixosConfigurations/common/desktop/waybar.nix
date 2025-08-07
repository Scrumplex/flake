{
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  cfg = config.hm.programs.waybar;
in {
  hm.catppuccin.waybar.enable = true;
  hm.programs.waybar = {
    enable = true;
    extraModules = {
      cameraBlank = {
        blanked.label = "󱜷";
        unblanked.label = "󰖠";
      };
      paMute = {
        enable = lib.mkDefault true;
        muted.label = "󰍭";
        unmuted.label = "󰍬";
      };
    };
    settings = let
      termapp = "${pkgs.termapp}/bin/termapp";
      run-or-raise = lib.getExe pkgs.run-or-raise;
    in {
      mainBar = {
        modules-left = ["niri/workspaces" "mpd"];
        modules-center = ["clock" "clock#other"];
        modules-right =
          [
            "network"
            "pulseaudio"
            "battery"
            "backlight"
          ]
          ++ lib.optional config.hm.programs.waybar.extraModules.paMute.enable
          "custom/${config.hm.programs.waybar.extraModules.paMute.moduleName}"
          ++ lib.optional config.hm.programs.waybar.extraModules.cameraBlank.enable
          "custom/${config.hm.programs.waybar.extraModules.cameraBlank.moduleName}"
          ++ [
            "power-profiles-daemon"
            "idle_inhibitor"
            "clock#date"
            "tray"
          ];
        "niri/workspaces" = {
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "messages" = "󰍩";
            "2" = ""; # this is not a material design circle like the other icons
            "3" = "󰝤";
            "4" = "󰔶";
          };
        };
        mpd = {
          format = "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ({volume}%) 󰎈";
          format-disconnected = "Disconnected 󰎈";
          format-stopped = "Stopped 󰎈";
          state-icons = {
            paused = "󰏤";
            playing = "󰐊";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-scroll-up = "${pkgs.mpc-cli}/bin/mpc vol +2 > /dev/null && ${pkgs.mpc-cli}/bin/mpc vol | ${pkgs.gnused}/bin/sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-scroll-down = "${pkgs.mpc-cli}/bin/mpc vol -2 > /dev/null && ${pkgs.mpc-cli}/bin/mpc vol | ${pkgs.gnused}/bin/sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-click = "uwsm app -- ${termapp} ${config.hm.programs.ncmpcpp.package}/bin/ncmpcpp";
          on-click-middle = "${pkgs.mpc-cli}/bin/mpc toggle";
          on-click-right = "";
          smooth-scrolling-threshold = 0.16;
        };
        network = {
          format = "{ifname}";
          format-wifi = "{essid} 󰖩";
          format-ethernet = "";
          format-disconnected = "disconnected 󰅤";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) 󰖩";
          tooltip-format-disconnected = "Disconnected";
          on-click = "uwsm app -- ${termapp} ${pkgs.nload}/bin/nload";
          max-length = 50;
          interval = 1;
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}󰂰";
          format-muted = "󰝟";
          format-icons = {
            headphones = "󰋋";
            handsfree = "󰋏";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰄜";
            car = "󰄍";
            default = "󰕾";
          };
          on-click = "uwsm app -- ${termapp} ${pkgs.pulsemixer}/bin/pulsemixer";
          on-scroll-up = "${pkgs.pamixer}/bin/pamixer -ui 2 && ${pkgs.pamixer}/bin/pamixer --get-volume > $XDG_RUNTIME_DIR/wob.sock";
          on-scroll-down = "${pkgs.pamixer}/bin/pamixer -ud 2 && ${pkgs.pamixer}/bin/pamixer --get-volume > $XDG_RUNTIME_DIR/wob.sock";
          smooth-scrolling-threshold = 0.16;
        };
        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["󱃍" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          max-length = 25;
          on-click = "uwsm app -- ${run-or-raise} powersupply ${lib.getExe pkgs.powersupply}";
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["󰃞" "󰃟" "󰃠"];
        };
        clock = {
          format = "{:%T}";
          interval = 1;
        };
        "clock#other" = {
          format = "{:%I:%M %p}";
          interval = 1;
          locale = "en_US.UTF-8";
          timezone = "America/New_York";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };
        power-profiles-daemon = {
          format-icons = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };
        "clock#date" = {
          format = "{:%a, %d. %b %Y}";
          interval = 1;
        };
        tray.spacing = 16;
      };
    };
    systemd.enable = true;
    style = ''
      window#waybar {
        font-family: "Monocraft";
        font-size: 10pt;
        background-color: @crust;
        color: @text;
      }

      .modules-left, .modules-center, .modules-right {
        margin-left: 8px;
        margin-right: 8px;
        border-radius: 16px;
        background-color: @base;
      }

      #workspaces, #mpd, #clock, #network, #pulseaudio, #battery, #backlight, #custom-pa-mute, #custom-camera-blank, #idle_inhibitor, #tray {
        margin: 0 8px;
      }

      #custom-pa-mute, #custom-camera-blank {
        margin-right: 0;
      }

      #idle_inhibitor, #custom-camera-blank {
        margin-left: 0;
      }

      #workspaces {
        margin-left: 0;
      }

      #workspaces button, #idle_inhibitor, #custom-pa-mute, #custom-camera-blank, #power-profiles-daemon {
        border: none;
        background-color: transparent;
        box-shadow: none;  /* dunno why this is set */
        border-radius: 16px;
        transition: background-color 100ms ease, color 100ms ease;
        /* make it 32px × 32px */
        min-width: 32px;
        min-height: 32px;
        padding: 0;
        font-weight: normal;
      }

      #workspaces button.urgent, #idle_inhibitor.activated, #custom-pa-mute.muted, #custom-camera-blank.blank {
        background-color: @peach;
        color: @base;
      }

      #custom-pa-mute.muted, #custom-camera-blank.blank {
        background-color: @red;
      }

      #idle_inhibitor.activated {
        background-color: @mauve;
      }

      #workspaces button:hover {
        background-image: none; /* remove Adwaita button gradient */
        background-color: @surface2;
      }

      #workspaces button:hover label {
        text-shadow: none; /* Adwaita? */
      }

      #workspaces button.focused {
        background-color: @blue;
        color: @crust;
      }

      #workspaces button.focused:hover {
        background-color: @sky;
      }

      #workspaces button:active, #workspaces button.focused:active {
        background-color: @text;
        color: @base;
      }

      #network.ethernet {
        padding: 0;
      }

      #battery.warning {
        color: @peach;
      }

      #battery.critical {
        color: @maroon;
      }

      #battery.charging {
        color: @green;
      }

      #clock.other {
        color: @subtext0;
      }
    '';
  };

  hm.systemd.user.services."waybar" = {
    Unit.After = ["graphical-session.target"];
    Service.Slice = ["app-graphical.slice"];
  };

  hm.wayland.windowManager.sway.config.keybindings = lib.mkMerge [
    (lib.mkIf cfg.extraModules.cameraBlank.enable (lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+n" cfg.extraModules.cameraBlank.onClickScript))
    (lib.mkIf cfg.extraModules.paMute.enable (lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+m" cfg.extraModules.paMute.onClickScript))
  ];

  hm.xsession.preferStatusNotifierItems = true;
}
