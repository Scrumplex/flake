{config, ...}: {
  hm.programs.htop = {
    enable = true;
    settings =
      {
        "delay" = 10;
        ".tree_view_always_by_pid" = 1;
        "tree_view" = 1;
      }
      // (with config.hm.lib.htop;
        leftMeters [
          (bar "LeftCPUs2")
          (bar "Memory")
          (bar "Swap")
        ])
      // (with config.hm.lib.htop;
        rightMeters [
          (bar "RightCPUs2")
          (text "Tasks")
          (text "LoadAverage")
          (text "Uptime")
        ]);
  };
}
