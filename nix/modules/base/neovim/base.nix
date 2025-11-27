{inputs, ...}: {
  flake.modules.nixos.base = {pkgs, ...}: {
    imports = [inputs.nixvim.nixosModules.nixvim];

    programs.vim.defaultEditor = false;

    programs.nixvim = {
      enable = true;

      nixpkgs.useGlobalPackages = true;

      defaultEditor = true;

      enableMan = false;

      extraPackages = with pkgs; [
        fd
        ripgrep
      ];
      opts = {
        title = true;

        wrap = true; # Override mini-basics
      };

      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "mocha";
      };

      plugins = {
        indent-blankline = {
          enable = true;
          settings.scope.enabled = false;
        };
        mini = {
          enable = true;
          mockDevIcons = true;
          modules = {
            basics = {
              options.extra_ui = true;
              mappings.windows = true;
              autocommands.relnum_in_visual_mode = true;
            };
            diff = {
              view.style = "sign";
            };
            icons = {};
            map = {};
            move = {};
            pairs = {};
            splitjoin = {};
            starter = {
              content_hooks = {
                "__unkeyed-1.adding_bullet" = {
                  __raw = "require('mini.starter').gen_hook.adding_bullet()";
                };
                "__unkeyed-2.indexing" = {
                  __raw = "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
                };
                "__unkeyed-3.padding" = {
                  __raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
                };
              };
              evaluate_single = true;
              items = {
                "__unkeyed-1.buildtin_actions" = {
                  __raw = "require('mini.starter').sections.builtin_actions()";
                };
                "__unkeyed-2.recent_files_current_directory" = {
                  __raw = "require('mini.starter').sections.recent_files(10, false)";
                };
                "__unkeyed-3.recent_files" = {
                  __raw = "require('mini.starter').sections.recent_files(10, true)";
                };
                "__unkeyed-4.sessions" = {
                  __raw = "require('mini.starter').sections.sessions(5, true)";
                };
              };
            };
            trailspace = {};
          };
        };
      };
    };
  };
}
