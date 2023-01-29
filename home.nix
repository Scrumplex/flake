{ config, pkgs, ... }:

{
  imports = [ ./modules/wlogout.nix ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "scrumplex";
  home.homeDirectory = "/home/scrumplex";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.git-crypt
    pkgs.xdg-user-dirs
    pkgs.xdg-utils
    pkgs.wl-clipboard
    pkgs.htop

    pkgs.pulsemixer
    pkgs.gtklock

    pkgs.discord
    pkgs.tdesktop
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.obs-studio
    pkgs.ark
    pkgs.evolution

    pkgs.steam
    pkgs.steam-run

    pkgs.fira
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
    pkgs.monocraft

    pkgs.catppuccin-cursors.mochaMaroon
    (pkgs.catppuccin-gtk.override {
      accents = ["teal"];
      variant = "mocha";
    })
    pkgs.gnome.gnome-themes-extra
  ];

  # Core tools
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    delta.enable = true;
    signing.key = "E13DFD4B47127951";
    signing.signByDefault = true;
    userEmail = "contact@scrumplex.net";
    userName = "Sefa Eyeoglu";
  };
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1209600;
    defaultCacheTtlSsh = 1209600;
    maxCacheTtl = 1209600;
    maxCacheTtlSsh = 1209600;
    extraConfig = "
      allow-preset-passphrase
    ";
  };
  programs.password-store.enable = true;
  services.gnome-keyring.enable = true;
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
          sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        };
      }
    ];
  };
  programs.bash = {
    enable = true;
    bashrcExtra = ''
if [ "$(ps -p $PPID -o comm=)" != "fish" ]; then
        exec fish
fi
'';
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Multimedia
  services.mpd = {
    enable = true;

    extraConfig = ''
zeroconf_enabled    "no"

filesystem_charset  "UTF-8"

restore_paused      "yes"

input_cache {
    size            "1 GB"
}

audio_output {
    type            "pulse"
    name            "Primary Audio Stream"
    format          "48000:32:2"
}

audio_output {
    type            "fifo"
    name            "FIFO"
    path            "~/.cache/mpd.fifo"
    format          "44100:16:2"
}
'';
  };
  programs.ncmpcpp.enable = true;

  # GUI tools
  programs.firefox.enable = true;
  programs.browserpass.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      modifier = "Mod4";
      input = {
        "type:keyboard" = {
          xkb_layout = "de";
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
        "2:14:ETPS/2_Elantech_Touchpad" = {
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
        "LG Display 0x046F Unknown" = {
          mode = "1920x1080@60Hz";
          position = "0,0";
        };
        "*" = {
          bg = "${./current-wallpaper.jpg} fill";
        };
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
      floating.criteria = [
        { app_id = "lxqt-policykit-agent"; }
      ];
      window = {
        border = 4;
        hideEdgeBorders = "smart";
        commands = [
          {
            criteria.app_id = "popup_pulsemixer";
            command = "floating enable; sticky enable; resize set 800 600; border pixel";
          }
          {
            criteria = { app_id = "firefox"; title = "Picture-in-Picture"; };
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
        names = [ "Monocraft" ];
        size = 10.0;
      };
      colors = 
        let
          cat_blue = "#89b4fa";
          cat_base = "#1e1e2e";
          cat_surface0 = "#313244";
          cat_pink = "#f5c2e7";
          cat_text = "#cdd6f4";
          cat_peach = "#fab387";
        in {
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
      keybindings = 
        let
          swayConf = config.wayland.windowManager.sway.config;
          mod = swayConf.modifier;
          left = swayConf.left;
          right = swayConf.right;
          up = swayConf.up;
          down = swayConf.down;
        in {
        "${mod}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${mod}+Escape" = "kill";
        "${mod}+d" = "exec ${config.wayland.windowManager.sway.config.menu}";
        "${mod}+p" = "exec ${pkgs.pass}/bin/passmenu --type";
        "${mod}+Shift+p" = "exec ${pkgs.pass}/bin/passmenu";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "${pkgs.wlogout}/bin/wlogout";
        "${mod}+Ctrl+q" = "exec ${pkgs.gtklock}/bin/gtklock";
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

        "XF86AudioStop" = "exec ${pkgs.mpc-cli}/bin/mpc stop";
        "XF86AudioPlay" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
        "XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
        "XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";
        "XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ui 2";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -ud 2";
        "${mod}+XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";
        "${mod}+m" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";
        "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.mpc-cli}/bin/mpc vol +2";
        "Shift+XF86AudioLowerVolume" = "exec ${pkgs.mpc-cli}/bin/mpc vol -2";
      };
    };
  };
  services.swayidle = {
    enable = true;
    events =
      let
        swaymsg = "${pkgs.sway}/bin/swaymsg";
        gtklock = "${pkgs.gtklock}/bin/gtklock";
      in [
      { event = "before-sleep"; command = gtklock; }
      { event = "after-resume"; command = "${swaymsg} \"output * dpms on\""; }
    ];
    timeouts =
      let
        swaymsg = "${pkgs.sway}/bin/swaymsg";
        gtklock = "${pkgs.gtklock}/bin/gtklock";
      in [
      { timeout = 240; command = "${swaymsg} \"output * dpms off\""; resumeCommand = "${swaymsg} \"output * dpms on\""; }
      { timeout = 300; command = gtklock; }
      { timeout = 600; command = "systemctl suspend"; }
    ];
  };
  programs.mako = {
    enable = true;
    # TODO: theme
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
	action = "systemctl poweroff";
	text = "Shutdown";
	keybind = "s";
      }
      {
        label = "hibernate";
	action = "systemctl hibernate";
	text = "Hibernate";
	keybind = "h";
      }
      {
        label = "suspend";
	action = "systemctl suspend";
	text = "Suspend";
	keybind = "u";
      }
      {
        label = "exit";
	action = "${pkgs.sway}/bin/swaymsg exit";
	text = "Exit";
	keybind = "e";
      }
      {
        label = "reboot";
	action = "systemctl reboot";
	text = "Reboot";
	keybind = "r";
      }
      {
        label = "lock";
	action = "${pkgs.gtklock}/bin/gtklock";
	text = "Lock";
	keybind = "l";
      }
    ];
    style = ''
window#waybar {
    font-family: "Fira Code";
    font-size: 10pt;
    color: #cdd6f4;  /* text */
}

button {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    border: none;
    background-color: #1e1e2e;
}

button:hover {
    background-color: #313244;  /* surface0 */
}

button:focus {
    background-color: #89b4fa;  /* blue */
    color: #1e1e2e;  /* base */
}

button:active {
    background-color: #cdd6f4;  /* text */
    color: #1e1e2e;  /* base */
}

#lock {
    background-image: image(url("${./lock.png}"));
}

#exit {
    background-image: image(url("${./exit-to-app.png}"));
}

#suspend {
    background-image: image(url("${./power-sleep.png}"));
}

#hibernate {
    background-image: image(url("${./power-cycle.png}"));
}

#shutdown {
    background-image: image(url("${./power.png}"));
}

#reboot {
    background-image: image(url("${./restart.png}"));
}'';
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        modules-left = [ "sway/workspaces" "mpd" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "pulseaudio" "battery" "custom/pa-mute" "idle_inhibitor" "clock#date" "tray" ];
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
          on-scroll-up = "${pkgs.mpc-cli}/bin/mpc vol +2 && ${pkgs.mpc-cli}/bin/mpc vol | sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-scroll-down = "${pkgs.mpc-cli}/bin/mpc vol -2 && ${pkgs.mpc-cli}/bin/mpc vol | sed 's|n/a|0%|g;s/[^0-9]*//g' > $XDG_RUNTIME_DIR/wob.sock";
          on-click = "termapp ncmpcpp";
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
                on-click = "termapp nload";
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
                on-click = "termapp pulsemixer";
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
        "custom/pa-mute" = {
            exec = "$HOME/.config/waybar/components/pa-mute";
            return-type = "json";
            on-click = "${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
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
    style = ''
window#waybar {
    font-family: "Monocraft";
    font-size: 10pt;
    background: RGBA(17, 17, 27, 0.95);  /* crust */
    color: #cdd6f4;  /* text */
}

.modules-left, .modules-center, .modules-right {
    margin-left: 8px;
    margin-right: 8px;
    background-color: #1e1e2e;  /* base */
    border-radius: 16px;
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
    background-color: #fab387;  /* peach */
    color: #1e1e2e;  /* base */
}

#custom-pa-mute.muted {
    background-color: #f38ba8; /* red */
}

#idle_inhibitor.activated {
    background-color: #cba6f7; /* mauve */
}

#workspaces button:hover {
    background-image: none; /* remove Adwaita button gradient */
    background-color: #585b70;  /* surface2 */
}

#workspaces button:hover label {
    text-shadow: none; /* Adwaita? */
}

#workspaces button.focused {
    background-color: #89b4fa;  /* blue */
    color: #161320;  /* black0 */
}

#workspaces button.focused:hover {
    background-color: #89dceb;  /* sky */
}

#workspaces button:active, #workspaces button.focused:active {
    background-color: #cdd6f4;  /* text */
    color: #1e1e2e;  /* base */
}

#network.ethernet {
    padding: 0;
}

#battery.warning {
    color: #fab387;  /* peach */
}

#battery.critical {
    color: #f38ba8;  /* maroon */
}

#battery.charging {
    color: #a6e3a1;  /* green */
}
'';
    systemd.enable = true;
  };
  services.wlsunset = {
    enable = true;
    latitude = "51.6";
    longitude = "10.1";
    temperature.day = 5700;
    temperature.night = 3000;
  };
  services.xembed-sni-proxy.enable = true;

  gtk = {
    enable = true;
    cursorTheme.name = "Catppuccin-Mocha-Maroon-Cursors";
    iconTheme.name = "Adwaita";
    font.name = "Fira Sans 11";
    theme.name = "Catppuccin-Mocha-Standard-Teal-Dark";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "gtk2";
  };

  programs.kitty = {
    enable = true;
    font.name = "Fira Code Regular Nerd Font Complete";
    theme = "Catppuccin-Mocha";
  };
}
