{lib, ...}: {
  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    ...
  }: {
    options.services.mpd.fifo = {
      name = lib.mkOption {
        default = "FIFO";
      };
      path = lib.mkOption {
        default = "~/.cache/mpd.fifo";
      };
    };
    config = {
      services.mpd = {
        enable = true;

        extraConfig = ''
          zeroconf_enabled "no"

          filesystem_charset "UTF-8"

          restore_paused "yes"

          input_cache {
            size "1 GB"
          }

          audio_output {
            type "pipewire"
            name "Primary Audio Stream"
            format "96000:32:2"
          }

          audio_output {
            type "fifo"
            name "${config.services.mpd.fifo.name}"
            path "${config.services.mpd.fifo.path}"
            format "44100:16:2"
          }
        '';
      };

      services.mpdris2.enable = true;

      home.packages = [
        pkgs.mpc
      ];

      wayland.windowManager.niri.settings.binds = {
        "XF86AudioStop" = {
          _props.allow-when-locked = true;
          spawn = ["mpc" "stop"];
        };
        "XF86AudioPlay" = {
          _props.allow-when-locked = true;
          spawn = ["mpc" "toggle"];
        };
        "XF86AudioPause" = {
          _props.allow-when-locked = true;
          spawn = ["mpc" "toggle"];
        };
        "XF86AudioPrev" = {
          _props.allow-when-locked = true;
          spawn = ["mpc" "prev"];
        };
        "XF86AudioNext" = {
          _props.allow-when-locked = true;
          spawn = ["mpc" "next"];
        };
        "Shift+XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = ["wob-mpc-volume" "decrease-volume"];
        };
        "Shift+XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = ["wob-mpc-volume" "increase-volume"];
        };
      };
    };
  };
}
