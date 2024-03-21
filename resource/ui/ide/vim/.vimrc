"================================================ PLUGINS
call plug#begin()

Plug 'github/copilot.vim'
Plug 'vim-autoformat/vim-autoformat'
Plug 'lunacookies/vim-sh'
Plug 'preservim/nerdtree'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'Skalyaeve/a-vim-theme'

call plug#end()

"================================================ CONFIG - PLUGINS
let g:python3_host_prog="/usr/bin/python3"

let g:NERDTreeShowFilesLines=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinSize=20
let g:NERDTreeShowFilesLines=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeMinimalMenu=0

let g:lsp_use_native_client=1
let g:lsp_semantic_enabled=1

"================================================ CONFIG - THEME
syntax on
if (has("termguicolors"))
    set termguicolors
endif
colorscheme neon

"================================================ CONFIG - VIM
filetype plugin indent on

set incsearch
set showmatch

set number
set mouse=a

set expandtab
set tabstop=4

set autoindent
set smartindent
set shiftwidth=4

set wrap
set whichwrap=b,s,>,<,[,]
set backspace=indent,eol,start

let g:mapleader=" "
source ~/.vim/binds.vim

"================================================ FILETYPES
autocmd BufRead,BufNewFile ~/.config/i3/*.conf set filetype=i3config
