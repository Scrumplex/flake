{lib, ...}: {
  flake.modules.homeManager.desktop = {config, ...}: {
    options.services.mpd.fifo = {
      name = lib.mkOption {
        default = "FIFO";
      };
      path = lib.mkOption {
        default = "~/.cache/mpd.fifo";
      };
    };
    config.services.mpd = {
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
  };
}
