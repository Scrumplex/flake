{
  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    ...
  }: {
    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {
        visualizerSupport = true;
      };
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
        visualizer_output_name = config.services.mpd.fifo.name;
        visualizer_data_source = config.services.mpd.fifo.path;
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
  };
}
