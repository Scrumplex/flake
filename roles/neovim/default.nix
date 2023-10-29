{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.neovim;
in {
  options.roles.neovim = {
    enable = mkEnableOption "neovim role";
  };
  config = mkIf cfg.enable {
    hm.programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        clang-tools # clangd lsp
        gcc # treesitter
        gopls # shellcheck lsp
        nil # nix lsp
        nixd # nix lsp
        nodePackages.bash-language-server # bashls lsp
        nodePackages.pyright # python
        nodePackages.typescript-language-server # typescript
        nodePackages.vscode-langservers-extracted # eslint/html/css/json lsp
        nodePackages.yaml-language-server # yaml lsp
        pylyzer # python
        python3Packages.python-lsp-server # python
        rust-analyzer # rust
        rustc # treesitter
        shellcheck # shellcheck lsp
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = suda-vim;
          config = "let g:suda_smart_edit = 1";
        }
        nvim-treesitter.withAllGrammars
        lualine-nvim
        neo-tree-nvim
        bufferline-nvim

        plenary-nvim
        gitsigns-nvim
        nvim-web-devicons
        nui-nvim

        nvim-lspconfig
        luasnip
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        nvim-cmp
        indent-blankline-nvim
      ];

      extraConfig = ''
        let mapleader=" "
        syntax enable
        filetype plugin on
      '';

      extraLuaConfig = ''
        vim.o.title = true;
        vim.o.termguicolors = true -- Use true colors, required for some plugins
        vim.wo.number = true
        vim.wo.signcolumn = "yes"

        vim.o.hlsearch = true
        vim.o.ignorecase = true -- Ignore case when using lowercase in search
        vim.o.smartcase = true -- But don't ignore it when using upper case

        vim.o.autoindent = true
        vim.o.smartindent = true

        vim.o.expandtab = true -- Convert tabs to spaces.
        vim.o.tabstop = 4
        vim.o.softtabstop = 4
        vim.o.shiftwidth = 4

        vim.o.splitbelow = true
        vim.o.splitright = true
        vim.o.mouse = "a"
        vim.o.clipboard = "unnamedplus"

        vim.o.fileencoding = "utf-8"
        vim.o.spell = false
        vim.o.spelllang = "en_us"
        vim.o.completeopt = "menu,menuone,noselect"

        local lualine = require("lualine")
        local gitsigns = require("gitsigns")

        local treesitter = require("nvim-treesitter.configs")

        local cmp = require("cmp")
        local nvim_lsp = require("lspconfig")
        local luasnip = require("luasnip")
        local bufferline = require("bufferline")

        lualine.setup()
        gitsigns.setup()

        treesitter.setup({
          sync_install = false,
          highlight = {
            enable = true,
          },
        })

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<C-e>"] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            -- Accept currently selected item. If none selected, `select` first item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
          }),
        })

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
          sources = {
            { name = "buffer" },
          },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        })

        -- language servers

        -- Mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "T", "<cmd>BufferLineCyclePrev<CR>", opts)
        vim.api.nvim_set_keymap("n", "t", "<cmd>BufferLineCycleNext<CR>", opts)
        vim.api.nvim_set_keymap("n", "<C-H>", "<cmd>BufferLineCyclePrev<CR>", opts)
        vim.api.nvim_set_keymap("n", "<C-L>", "<cmd>BufferLineCycleNext<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>Neotree reveal<CR>", opts)

        vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
          vim.api.nvim_buf_set_keymap(
            bufnr,
            "n",
            "<leader>wl",
            "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
            opts
          )
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end

        local servers = { "bashls", "clangd", "cssls", "eslint", "gopls", "html", "jsonls", "nil_ls", "nixd", "pylsp", "pylyzer", "pyright", "rust_analyzer", "tsserver", "yamlls" }

        for _, lsp in pairs(servers) do
          nvim_lsp[lsp].setup({
            on_attach = on_attach,
          })
        end

        bufferline.setup()

      '';
    };
  };
}
