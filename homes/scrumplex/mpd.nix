{ config, pkgs, ... }:

let
  mpdFifoName = "FIFO";
  mpdFifoPath = "~/.cache/mpd.fifo";
in {
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
        type "pulse"
        name "Primary Audio Stream"
        format "48000:32:2"
      }

      audio_output {
        type "fifo"
        name "${mpdFifoName}"
        path "${mpdFifoPath}"
        format "44100:16:2"
      }
    '';
  };
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    bindings = [
      {
        key = "9";
        command = "show_clock";
      }
      {
        key = "f";
        command = "seek_forward";
      }
      {
        key = "F";
        command = "seek_backward";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "space";
        command = "jump_to_playing_song";
      }
    ];
    settings = {
      visualizer_data_source = mpdFifoPath;
      visualizer_output_name = mpdFifoName;
      visualizer_in_stereo = "yes";

      volume_change_step = 2;
      connected_message_on_startup = "no";
      clock_display_seconds = "yes";
      display_bitrate = "yes";

      visualizer_color = "cyan";
      empty_tag_color = "red:b";
      header_window_color = "cyan";
      volume_color = "cyan:b";
      state_line_color = "black:b";
      state_flags_color = "blue:b";
      main_window_color = "white";
      color1 = "blue";
      color2 = "green";
      progressbar_color = "black:b";
      progressbar_elapsed_color = "blue:b";
      statusbar_color = "cyan";
      statusbar_time_color = "cyan:b";
      player_state_color = "green:b";
    };
  };
}
