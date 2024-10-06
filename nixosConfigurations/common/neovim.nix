{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nixvim.nixosModules.nixvim];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    enableMan = false;

    extraPackages = with pkgs; [
      fd
      ripgrep
    ];

    globals = {
      mapleader = " ";
    };
    opts = {
      title = true;
      termguicolors = true; # Use true colors, required for some plugins
      number = true;
      signcolumn = "yes";

      hlsearch = true;
      ignorecase = true; # Ignore case when using lowercase in search
      smartcase = true; # But don't ignore it when using upper case

      autoindent = true;
      smartindent = true;

      expandtab = true; # Convert tabs to spaces.
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;

      splitbelow = true;
      splitright = true;
      mouse = "a";

      fileencoding = "utf-8";
      spell = false;
      spelllang = "en_us";
      completeopt = "menu,menuone,noselect";
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
      alpha = {
        enable = true;
        theme = "startify";
      };
      bufferline.enable = true;
      cmp = {
        enable = true;
        cmdline = {
          "/" = {
            sources = [{name = "buffer";}];
          };
          ":" = {
            sources = lib.warn "TODO: path and cmdline are in separate groups" [
              {name = "path";}
              {name = "cmdline";}
            ];
          };
        };
        settings = {
          sources = lib.warn "TODO: groupIndex is not a thing anymore" [
            {
              name = "nvim_lsp";
              groupIndex = 1;
            }
            {
              name = "luasnip";
              groupIndex = 1;
            }
            {
              name = "buffer";
              groupIndex = 2;
            }
          ];
          mapping.__raw = ''
            cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            })
          '';
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };
      };
      gitsigns.enable = true;
      indent-blankline = {
        enable = true;
        settings.scope.enabled = false;
      };
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
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
          cmake.enable = true;
          cssls.enable = true;
          eslint.enable = true;
          gopls.enable = true;
          harper-ls.enable = true;
          helm-ls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          marksman.enable = true;
          nil-ls.enable = true;
          nixd.enable = true;
          openscad-lsp.enable = true;
          prismals.enable = true;
          pylsp.enable = true;
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };
          tailwindcss.enable = true;
          terraformls.enable = true;
          ts-ls.enable = true;
          yamlls.enable = true;
        };
      };
      luasnip.enable = true;
      lualine = {
        enable = true;
        settings.ignore_focus = [
          "alpha"
          "neo-tree"
          "Trouble"
        ];
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>fb" = "buffers";
          "<leader> " = "git_files";
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };
      treesitter = {
        enable = true;
        folding = false;
        settings.indent.enable = true;
      };
      trouble = {
        enable = true;
        settings = {
          use_diagnostic_signs = true;
          modes."diagnostics" = {
            auto_open = true;
            auto_close = true;
          };
        };
      };
      web-devicons.enable = true;
    };

    keymaps = let
      defaultOpts = {
        noremap = true;
        silent = true;
      };

      mkNMap = key: action: {
        inherit key action;
        mode = "n";
        options = defaultOpts;
      };
    in [
      (mkNMap "T" "<cmd>BufferLineCyclePrev<CR>")
      (mkNMap "t" "<cmd>BufferLineCycleNext<CR>")
      (mkNMap "<leader>n" "<cmd>Trouble diagnostics open focus=true<CR>")
      (mkNMap "<leader>t" "<cmd>Neotree reveal<CR>")
      (mkNMap "<leader>xx" "<cmd>TroubleToggle<CR>")
      (mkNMap "<leader>xw" "<cmd>TroubleToggle workspace_diagnostics<CR>")
      (mkNMap "<leader>xd" "<cmd>TroubleToggle document_diagnostics<CR>")
      (mkNMap "gR" "<cmd>TroubleToggle lsp_references<CR>")
    ];
  };
}
