{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.barbar = {
      enable = true;
      keymaps = {
        next.key = "t";
        previous.key = "T";
      };
    };
  };
}
