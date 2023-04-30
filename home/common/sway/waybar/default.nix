{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = let
      termapp = "${pkgs.termapp}/bin/termapp";
    in {
      mainBar = {
        position = "top";
        modules-left = ["sway/workspaces" "mpd"];
        modules-center = ["clock" "clock#other"];
        modules-right = [
          "network"
          "pulseaudio"
          "battery"
          "custom/pa-mute"
          "custom/camera-blank"
          "idle_inhibitor"
          "clock#date"
          "tray"
        ];
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "ﱣ";
            "2" = "ﱢ";
            "3" = "卑";
            "4:mail" = "";
            "5:chat" = "";
          };
          persistent_workspaces = {
            "1" = [];
            "2" = [];
          };
        };
        mpd = {
          format = "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ({volume}%) ";
          format-disconnected = "Disconnected ";
          format-stopped = "Stopped ";
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-scroll-up = "${pkgs.mpc-cli}/bin/mpc vol +2 > /dev/null && ${pkgs.mpc-cli}/bin/mpc vol | ${pkgs.gnused}/bin/sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-scroll-down = "${pkgs.mpc-cli}/bin/mpc vol -2 > /dev/null && ${pkgs.mpc-cli}/bin/mpc vol | ${pkgs.gnused}/bin/sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-click = "${termapp} ${config.programs.ncmpcpp.package}/bin/ncmpcpp";
          on-click-middle = "${pkgs.mpc-cli}/bin/mpc toggle";
          on-click-right = "";
          smooth-scrolling-threshold = 0.16;
        };
        network = {
          format = "{ifname}";
          format-wifi = "{essid} 直";
          format-ethernet = "";
          format-disconnected = "disconnected ";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) 直";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          on-click = "${termapp} ${pkgs.nload}/bin/nload";
          max-length = 50;
          interval = 1;
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "ﱝ";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = "墳";
          };
          on-click = "${termapp} ${pkgs.pulsemixer}/bin/pulsemixer";
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
          format-icons = ["" "" "" "" ""];
          max-length = 25;
        };
        clock = {
          format = "{:%T}";
          interval = 1;
        };
        "clock#other" = {
          format = "{:%H:%M %p}";
          interval = 1;
          locale = "en_US";
          timezone = "America/New_York";
        };
        "custom/pa-mute" = import ./modules/pa-mute.nix pkgs;
        "custom/camera-blank" = import ./modules/camera-blank.nix {
          inherit pkgs;
          device = "/dev/v4l/by-id/usb-046d_Logitech_Webcam_C925e_D8A39E5F-video-index0";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
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
    style = with config.theme.colors; ''
      window#waybar {
        font-family: "Monocraft";
        font-size: 10pt;
        background-color: #${crust};
        color: #${text};
      }

      .modules-left, .modules-center, .modules-right {
        margin-left: 8px;
        margin-right: 8px;
        border-radius: 16px;
        background-color: #${base};
      }

      #workspaces, #mpd, #clock, #network, #pulseaudio, #battery, #custom-pa-mute, #custom-camera-blank, #idle_inhibitor, #tray {
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

      #workspaces button, #idle_inhibitor, #custom-pa-mute, #custom-camera-blank {
        border: none;
        background-color: transparent;
        box-shadow: none;  /* dunno why this is set */
        border-radius: 16px;
        transition: background-color 100ms ease, color 100ms ease;
        /* make it 32px × 32px */
        min-width: 32px;
        min-height: 32px;
        padding: 0;
      }

      #workspaces button.urgent, #idle_inhibitor.activated, #custom-pa-mute.muted, #custom-camera-blank.blank {
        background-color: #${peach};
        color: #${base};
      }

      #custom-pa-mute.muted, #custom-camera-blank.blank {
        background-color: #${red};
      }

      #idle_inhibitor.activated {
        background-color: #${mauve};
      }

      #workspaces button:hover {
        background-image: none; /* remove Adwaita button gradient */
        background-color: #${surface2};
      }

      #workspaces button:hover label {
        text-shadow: none; /* Adwaita? */
      }

      #workspaces button.focused {
        background-color: #${blue};
        color: #${crust};
      }

      #workspaces button.focused:hover {
        background-color: #${sky};
      }

      #workspaces button:active, #workspaces button.focused:active {
        background-color: #${text};
        color: #${base};
      }

      #network.ethernet {
        padding: 0;
      }

      #battery.warning {
        color: #${peach};
      }

      #battery.critical {
        color: #${maroon};
      }

      #battery.charging {
        color: #${green};
      }

      #clock.other {
        color: #${subtext0};
      }
    '';
  };
}
