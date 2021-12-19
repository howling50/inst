set nocompatible
if (has("termguicolors"))
   set termguicolors
endif
filetype off
filetype plugin on
filetype indent on
set cursorline
set visualbell
set termencoding=utf-8
set encoding=utf-8
syntax on
set number
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

" PlugInstall [name ...] [#threads] 	Install plugins
" PlugUpdate [name ...] [#threads] 	Install or update plugins
" PlugClean[!] 	Remove unlisted plugins (bang version will clean without prompt)
" PlugUpgrade 	Upgrade vim-plug itself
" PlugStatus 	Check the status of plugins
" PlugDiff 	Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path] 	Generate script for restoring the current snapshot of the plugins


set nobackup
set shiftwidth=4
set tabstop=4
set scrolloff=10
set nowrap
set showcmd
set showmode
set history=100
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set t_Co=256
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>
map <leader><space> :let @/=''<cr> " clear search
set hidden
