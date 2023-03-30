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
        modules-center = ["clock"];
        modules-right = [
          "network"
          "pulseaudio"
          "battery"
          "custom/pa-mute"
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
          format = "{:%H:%M:%S}";
          interval = 1;
        };
        "custom/pa-mute" = let
          pamixer = "${pkgs.pamixer}/bin/pamixer";
          jq = "${pkgs.jq}/bin/jq";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
          grep = "${pkgs.gnugrep}/bin/grep";
        in {
          exec = pkgs.writeShellScript "pa-mute.sh" ''
            # Based on https://git.sr.ht/~whynothugo/dotfiles/tree/adf6af990b0348974b657ed4241d4bcf83dbcea3/item/home/.local/lib/waybar-mic
            # Copyright (c) 2012-2021, Hugo Osvaldo Barrera <hugo@barrera.io>
            # Copyright (c) 2021,2023, Sefa Eyeoglu <contact@scrumplex.net>
            #
            # Permission to use, copy, modify, and/or distribute this software for any
            # purpose with or without fee is hereby granted, provided that the above
            # copyright notice and this permission notice appear in all copies.
            #
            # THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
            # REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
            # FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
            # INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
            # LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
            # OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
            # PERFORMANCE OF THIS SOFTWARE.


            show() {
              muted=$(${pamixer} --default-source --get-mute 2> /dev/null)
              if [ "$muted" == "true" ]; then
                CLASS="muted"
                TEXT=""
              else
                CLASS="not-muted"
                TEXT=""
              fi

              ${jq} --compact-output \
                --null-input \
                --arg text "$TEXT" \
                --arg class "$CLASS" \
                '{"text": $text, "class": $class}'
            }

            monitor() {
              show

              ${pactl} subscribe | ${grep} --line-buffered "'change' on source" |
                while read -r _; do
                  show
                done
              exit
            }

            monitor
          '';
          return-type = "json";
          on-click = "${pamixer} --default-source --toggle-mute";
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

      #workspaces, #mpd, #clock, #network, #pulseaudio, #battery, #custom-pa-mute, #idle_inhibitor, #tray {
        margin: 0 8px;
      }

      #custom-pa-mute {
        margin-right: 0;
      }

      #idle_inhibitor {
        margin-left: 0;
      }

      #workspaces {
        margin-left: 0;
      }

      #workspaces button, #idle_inhibitor, #custom-pa-mute {
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

      #workspaces button.urgent, #idle_inhibitor.activated, #custom-pa-mute.muted {
        background-color: #${peach};
        color: #${base};
      }

      #custom-pa-mute.muted {
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
    '';
  };
}
