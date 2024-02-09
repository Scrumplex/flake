{config, ...}: {
  hm.services.wob = {
    enable = true;
    settings."" = with config.hm.theme.colors; {
      border_offset = 0;
      border_size = 2;
      bar_padding = 8;
      border_color = "${sky}ff";
      background_color = "${crust}e6";
      bar_color = "${sky}ff";
    };
  };
}
