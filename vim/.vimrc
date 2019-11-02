set encoding=UTF-8

set mouse=a
set number
set spell
set spelllang=en,de

set expandtab
set autoindent

set hlsearch
set ignorecase
set smartcase

syntax enable
filetype plugin on

call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/sudo.vim'
Plug 'leifdenby/vim-spellcheck-toggle'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

:AirlineTheme dark
let g:airline_powerline_fonts = 1

