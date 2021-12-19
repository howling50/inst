set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set number
set ignorecase
set smartcase
set hlsearch
" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'ap/vim-css-color'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

call plug#end()
nnoremap <C-e> :NERDTree<CR>
let NERDTreeShowHidden=1

set laststatus=2
if !has('gui_running')
  set t_Co=256
endif

" :PlugInstall
" :PlugUpdate
" :PlugClear
