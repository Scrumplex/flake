{ config, pkgs, ... }:

let termapp = "${pkgs.termapp}/bin/termapp";
in {
  imports = [ ./wob.nix ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      modifier = "Mod4";
      startup = [{
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
        "*" = { bg = "${./current-wallpaper.jpg} fill"; };
      };
      assigns = {
        "4:mail" = [{ app_id = "evolution"; }];
        "5:chat" = [
          { app_id = "org.telegram.desktop"; }
          { class = "Signal"; }
          { class = "Element"; }
          { app_id = "Element"; }
          { class = "discord"; }
        ];
      };
      floating.criteria = [{ app_id = "lxqt-policykit-agent"; }];
      window = {
        border = 4;
        hideEdgeBorders = "smart";
        commands = [
          {
            criteria.app_id = "popup_pulsemixer";
            command =
              "floating enable; sticky enable; resize set 800 600; border pixel";
          }
          {
            criteria = {
              app_id = "firefox";
              title = "Picture-in-Picture";
            };
            command = "floating enable; sticky enable";
          }
          {
            criteria.title = ".*";
            command = "inhibit_idle fullscreen";
          }
        ];
      };
      bars = [ ];
      fonts = {
        names = [ "Monocraft" ];
        size = 10.0;
      };
      colors = let
        cat_blue = "#89b4fa";
        cat_base = "#1e1e2e";
        cat_surface0 = "#313244";
        cat_pink = "#f5c2e7";
        cat_text = "#cdd6f4";
        cat_peach = "#fab387";
      in {
        # TODO: create catppuccin module
        focused = {
          background = cat_blue;
          border = cat_blue;
          childBorder = cat_blue;
          indicator = cat_blue;
          text = cat_base;
        };
        focusedInactive = {
          background = cat_surface0;
          border = cat_surface0;
          childBorder = cat_surface0;
          indicator = cat_surface0;
          text = cat_pink;
        };
        unfocused = {
          background = cat_base;
          border = cat_base;
          childBorder = cat_base;
          indicator = cat_base;
          text = cat_text;
        };
        urgent = {
          background = cat_peach;
          border = cat_peach;
          childBorder = cat_peach;
          indicator = cat_peach;
          text = cat_base;
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
        "${mod}+p" = "exec ${pkgs.pass}/bin/passmenu --type";
        "${mod}+Shift+p" = "exec ${pkgs.pass}/bin/passmenu";
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

        "XF86AudioMute" =
          "exec ${pamixer} -t && ${pamixer} --get-volume > $XDG_RUNTIME_DIR/wob.sock";
        "XF86AudioRaiseVolume" =
          "exec ${pamixer} -ui 2 && ${pamixer} --get-volume > $XDG_RUNTIME_DIR/wob.sock";
        "XF86AudioLowerVolume" =
          "exec ${pamixer} -ud 2 && ${pamixer} --get-volume > $XDG_RUNTIME_DIR/wob.sock";

        "${mod}+XF86AudioMute" = "exec ${pamixer} --default-source -t";
        "${mod}+m" = "exec ${pamixer} --default-source -t";

        "Shift+XF86AudioRaiseVolume" =
          "exec ${mpc} vol +2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
        "Shift+XF86AudioLowerVolume" =
          "exec ${mpc} vol -2 && ${mpc} vol | ${sed} 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";

        "XF86MonBrightnessDown" =
          "exec ${brightnessctl} set 5%- | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $XDG_RUNTIME_DIR/wob.sock";
        "XF86MonBrightnessUp" =
          "exec ${brightnessctl} set 5%+ | ${sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $XDG_RUNTIME_DIR/wob.sock";
      };
    };
  };
  services.swayidle = let
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    gtklock = "${pkgs.gtklock}/bin/gtklock -d";
    systemctl = "${pkgs.systemd}/bin/systemctl";
  in {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${gtklock}; ${swaymsg} 'output * power on'";
      }
      {
        event = "after-resume";
        command = "${swaymsg} 'output * power on'";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 600;
        command = "${systemctl} suspend";
      }
    ];
  };
  programs.mako = {
    enable = true;
    font = "Monocraft 10";
    borderRadius = 12;
    borderSize = 2;
    backgroundColor = "#1e1e2e"; # base
    textColor = "#cdd6f4"; # text
    borderColor = "#89b4fa"; # blue
    progressColor = "over #313244"; # surface0
    extraConfig = ''
      [urgency=critical]
      layer=overlay
      anchor=top-center
      # maroon
      border-color=#eba0ac

      [mode=dnd]
      invisible=1
    '';
  };
  programs.wlogout = {
    enable = true;
    layout = let
      swaymsg = "${pkgs.sway}/bin/swaymsg";
      gtklock = "${pkgs.gtklock}/bin/gtklock -d";
      systemctl = "${pkgs.systemd}/bin/systemctl";
    in [
      {
        label = "shutdown";
        action = "${systemctl} poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "${systemctl} hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "${systemctl} suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "exit";
        action = "${swaymsg} exit";
        text = "Exit";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "${systemctl} reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "lock";
        action = gtklock;
        text = "Lock";
        keybind = "l";
      }
    ];
    style = import ./wlogout.css.nix;
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        modules-left = [ "sway/workspaces" "mpd" ];
        modules-center = [ "clock" ];
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
            "1" = [ ];
            "2" = [ ];
          };
        };
        mpd = {
          format =
            "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ({volume}%) ";
          format-disconnected = "Disconnected ";
          format-stopped = "Stopped ";
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-scroll-up =
            "${pkgs.mpc-cli}/bin/mpc vol +2 && ${pkgs.mpc-cli}/bin/mpc vol | ${pkgs.gnused}/bin/sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-scroll-down =
            "${pkgs.mpc-cli}/bin/mpc vol -2 && ${pkgs.mpc-cli}/bin/mpc vol | ${pkgs.gnused}/bin/sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-click =
            "${termapp} ${config.programs.ncmpcpp.package}/bin/ncmpcpp";
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
          on-scroll-up =
            "${pkgs.pamixer}/bin/pamixer -ui 2 && ${pkgs.pamixer}/bin/pamixer --get-volume > $XDG_RUNTIME_DIR/wob.sock";
          on-scroll-down =
            "${pkgs.pamixer}/bin/pamixer -ud 2 && ${pkgs.pamixer}/bin/pamixer --get-volume > $XDG_RUNTIME_DIR/wob.sock";
          smooth-scrolling-threshold = 0.16;
        };
        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
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
    style = ./waybar.css;
    systemd.enable = true;
  };
  services.wlsunset = {
    enable = true;
    latitude = "51.6";
    longitude = "10.1";
    temperature.day = 5700;
    temperature.night = 3000;
  };

  home.packages = with pkgs; [ wl-clipboard gtklock pulsemixer ];
}
