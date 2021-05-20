set encoding=UTF-8


set mouse=a
set number

set expandtab
set autoindent

set hlsearch
set ignorecase
set smartcase
set clipboard=unnamed
set nospell


syntax enable
filetype plugin on


call plug#begin('~/.vim/plugged')

Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', {
\ '_': ['ale'],
\})

let g:airline_powerline_fonts=1
let g:suda_smart_edit = 1

colorscheme nord

