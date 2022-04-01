set encoding=UTF-8

set mouse=a
set number
set termguicolors

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

set hlsearch
set ignorecase
set smartcase
set clipboard+=unnamedplus
set nospell

set completeopt=menu,menuone,noselect

syntax enable
filetype plugin on

call plug#begin('~/.local/share/nvim/plugged')
Plug 'lambdalisue/suda.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-lualine/lualine.nvim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'sbdchd/neoformat'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'lervag/vimtex'
Plug 'digitaltoad/vim-pug'
call plug#end()

let g:airline_powerline_fonts=1
let g:suda_smart_edit = 1

colorscheme catppuccin

" Keymap
let mapleader=" "
nnoremap <silent> <C-S-I> :Neoformat<CR>

nnoremap <silent> T :BufferLineCyclePrev<CR>
nnoremap <silent> t :BufferLineCycleNext<CR>
nnoremap <silent> <C-H> :BufferLineCyclePrev<CR>
nnoremap <silent> <C-L> :BufferLineCycleNext<CR>
nnoremap <silent> <leader>t :CHADopen<CR>


lua << EOF
local catppuccin = require('catppuccin')
local lualine = require('lualine')
local gitsigns = require('gitsigns')

local treesitter = require('nvim-treesitter.configs')

local cmp = require('cmp')
local nvim_lsp = require('lspconfig')
local luasnip = require('luasnip')
local bufferline = require('bufferline')

catppuccin.setup()
lualine.setup()
gitsigns.setup()

treesitter.setup({
    ensure_installed = "maintained",
    sync_install = false,
    highlight = {
        enable = true
    }
})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- language servers

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = { 'bashls', 'clangd', 'eslint', 'pylsp', 'yamlls' }

for _, lsp in pairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach
  }
end

nvim_lsp.cssls.setup {
    cmd = { "vscode-css-languageserver", "--stdio" },
    on_attach = on_attach
}
nvim_lsp.html.setup {
    cmd = { "vscode-html-languageserver", "--stdio" },
    on_attach = on_attach
}
nvim_lsp.jsonls.setup {
    cmd = { "vscode-json-languageserver", "--stdio" },
    on_attach = on_attach
}
nvim_lsp.rls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        rust = {
            build_on_save = true,
        },
    },
}


bufferline.setup()

local chadtree_settings = {
    ["xdg"] = true,
    ["view.sort_by"] = {"is_folder", "file_name"}
}
vim.api.nvim_set_var("chadtree_settings", chadtree_settings)

EOF
