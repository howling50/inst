" vim-plug
call plug#begin('~/.config/nvim/')

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
