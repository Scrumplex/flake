{
  flake.modules.nixos.base.programs.nixvim = {
    opts = {
      expandtab = true; # Convert tabs to spaces.
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
    };

    files = {
      "ftplugin/nix.lua" = {
        opts = {
          shiftwidth = 2;
          softtabstop = 2;
          tabstop = 2;
        };
      };
    };
  };
}
