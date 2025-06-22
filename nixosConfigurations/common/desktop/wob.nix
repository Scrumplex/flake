{config, ...}: {
  hm.services.wob = {
    enable = true;
    settings."" = {
      border_offset = 0;
      border_size = 2;
      bar_padding = 8;
      # TODO: get these from somewhere else
      border_color = "89dcebff";
      background_color = "11111be6";
      bar_color = "89dcebff";
    };
  };
}
