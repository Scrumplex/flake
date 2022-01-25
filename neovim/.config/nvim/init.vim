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
nnoremap <C-S-I> :Neoformat<CR>

nnoremap <C-Left> :BufferLineCyclePrev<CR>
nnoremap <C-Right> :BufferLineCycleNext<CR>
nnoremap <C-H> :BufferLineCyclePrev<CR>
nnoremap <C-L> :BufferLineCycleNext<CR>
nnoremap <C-W> :bd<CR>


" LSP, Auto Completion and Snippets
lua << EOF
local catppuccin = require('catppuccin')
local lualine = require('lualine')
local gitsigns = require('gitsigns')

local cmp = require('cmp')
local nvim_lsp = require('lspconfig')
local luasnip = require('luasnip')
local bufferline = require('bufferline')

catppuccin.setup()
lualine.setup()
gitsigns.setup()

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

nvim_lsp.bashls.setup {}
nvim_lsp.clangd.setup {}
nvim_lsp.cssls.setup {
    cmd = { "vscode-css-languageserver", "--stdio" }
}
nvim_lsp.eslint.setup {}
nvim_lsp.html.setup {
    cmd = { "vscode-html-languageserver", "--stdio" }
}
nvim_lsp.jsonls.setup {
    cmd = { "vscode-json-languageserver", "--stdio" }
}
nvim_lsp.pylsp.setup {}
nvim_lsp.rls.setup {
    capabilities = capabilities,
    settings = {
        rust = {
            build_on_save = true,
        },
    },
}
nvim_lsp.yamlls.setup {}


bufferline.setup()

EOF
