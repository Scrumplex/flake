{
  flake.modules.nixos.base = {
    nixpkgs.allowedUnfreePackageNames = ["barbar.nvim"];

    programs.nixvim = {
      plugins.barbar = {
        enable = true;
        keymaps = {
          next.key = "t";
          previous.key = "T";
        };
      };
    };
  };
}
