vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    use 'lambdalisue/suda.vim'
    use 'editorconfig/editorconfig-vim'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    use 'nvim-lualine/lualine.nvim'
    use {'catppuccin/nvim', as = 'catppuccin'}
    use {'ms-jpq/chadtree', branch = 'chad', run = ':CHADdeps'}
    use 'kyazdani42/nvim-web-devicons'
    use 'akinsho/bufferline.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'lewis6991/gitsigns.nvim'

    use 'neovim/nvim-lspconfig'
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/nvim-cmp'
    use 'sbdchd/neoformat'
    use 'lukas-reineke/indent-blankline.nvim'

    use 'rust-lang/rust.vim'
    use 'dag/vim-fish'
    use 'lervag/vimtex'
    use 'digitaltoad/vim-pug'
end)
