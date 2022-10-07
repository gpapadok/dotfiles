call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'guns/vim-sexp',    {'for': 'clojure'}
Plug 'liquidz/vim-iced', {'for': 'clojure'}

Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'

" theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

call plug#end()

let g:iced_enable_default_key_mappings = v:true
let g:rainbow_active = 1

nnoremap <silent> <C-b> :NERDTreeToggle<CR>
nnoremap <silent> <C-p> :Files<CR>

colorscheme tokyonight-storm

filetype plugin indent on
syntax on
set number relativenumber
set expandtab smarttab
set nowrap
