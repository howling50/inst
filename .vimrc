set nocompatible
filetype on
filetype plugin on
filetype indent on
set cursorline
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


set nobackup
set shiftwidth=4
set tabstop=4
set scrolloff=10
set nowrap
set incsearch
set showcmd
set showmode
set showmatch
set history=100
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx