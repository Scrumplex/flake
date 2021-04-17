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

Plug 'vim-scripts/sudo.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'editorconfig/editorconfig-vim'

call plug#end()

let g:airline_powerline_fonts=1

colorscheme nord
