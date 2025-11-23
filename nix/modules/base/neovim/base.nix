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

        expandtab = true; # Convert tabs to spaces.
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;

        wrap = true; # Override mini-basics
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

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
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
        lsp = {
          enable = true;
          keymaps = {
            silent = true;
            diagnostic = {
              "<leader>j" = "goto_next";
              "<leader>k" = "goto_prev";
              "<leader>e" = "open_float";
              "<leader>q" = "setloclist";
            };
            lspBuf = {
              "gD" = "declaration";
              "gd" = "definition";
              "gi" = "implementation";
              "gr" = "references";
              "K" = "hover";
              "<C-k>" = "signature_help";
              "<leader>wa" = "add_workspace_folder";
              "<leader>wr" = "remove_workspace_folder";
              "<leader>D" = "type_definition";
              "<leader>rn" = "rename";
              "<leader>ca" = "code_action";
              #"<leader>f" = "formatting"; ?
            };
          };

          servers = {
            astro.enable = true;
            bashls.enable = false;
            clangd.enable = true;
            cssls.enable = true;
            eslint.enable = true;
            gopls.enable = true;
            harper_ls.enable = true;
            helm_ls.enable = true;
            html.enable = true;
            jsonls.enable = true;
            marksman.enable = true;
            nil_ls.enable = true;
            nixd.enable = true;
            pylsp.enable = true;
            pyright.enable = true;
            rust_analyzer = {
              enable = true;
              installRustc = false;
              installCargo = false;
            };
            tailwindcss.enable = true;
            terraformls.enable = true;
            ts_ls.enable = true;
            yamlls.enable = true;
          };
        };
        luasnip.enable = true;
        treesitter = {
          enable = true;
          folding = false;
          settings.indent.enable = true;
        };
      };
    };
  };
}
