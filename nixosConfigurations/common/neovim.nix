{inputs, ...}: {
  imports = [inputs.nixvim.nixosModules.nixvim];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
    };
    options = {
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

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
    };

    plugins = {
      bufferline.enable = true;
      gitsigns.enable = true;
      indent-blankline = {
        enable = true;
        scope.enabled = false;
      };
      neo-tree.enable = true;
      nvim-cmp = {
        enable = true;
        mapping = {
          "<C-b>" = {
            action = "cmp.mapping.scroll_docs(-4)";
            modes = ["i" "c"];
          };
          "<C-f>" = {
            action = "cmp.mapping.scroll_docs(4)";
            modes = ["i" "c"];
          };
          "<C-Space>" = {
            action = "cmp.mapping.complete()";
            modes = ["i" "c"];
          };
          "<C-e>" = ''
            cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            })
          '';
          "<CR>" = {
            action = "cmp.mapping.confirm({ select = true })";
          };
        };
        snippet.expand = "luasnip";
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
          {name = "cmdlist";}
        ];
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
          bashls.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          cssls.enable = true;
          eslint.enable = true;
          gopls.enable = true;
          html.enable = true;
          #jdtls.enable = true;
          jsonls.enable = true;
          nil_ls.enable = true;
          nixd.enable = true;
          pylsp.enable = true;
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };
          tsserver.enable = true;
          yamlls.enable = true;
        };
      };
      luasnip.enable = true;
      lualine.enable = true;
      treesitter = {
        enable = true;
        indent = true;
      };
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
      (mkNMap "<leader>t" "<cmd>Neotree reveal<CR>")
    ];
  };
}
