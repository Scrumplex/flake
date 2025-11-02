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

      home.packages = [
        pkgs.mpc
        (pkgs.writeShellApplication {
          name = "wob-mpc-volume";

          runtimeInputs = [pkgs.mpc];

          text = ''
            case "$1" in
              increase-volume)
                mpc volume +2
                ;;
              decrease-volume)
                mpc volume -2
                ;;
            esac

            systemctl --user is-active wob.socket || exit 0
            wob_socket=$(systemctl --user show --value --property Listen wob.socket | cut -d" " -f1)

            volume=$(mpc volume | grep -oE '[0-9]+')
            echo "$volume" | tee "$wob_socket"
          '';
        })
      ];

      programs.niri.settings.binds = with config.lib.niri.actions; {
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
          action = spawn ["wob-mpc-volume" "decrease-volume"];
        };
        "Shift+XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = spawn ["wob-mpc-volume" "increase-volume"];
        };
      };
    };
  };
}
