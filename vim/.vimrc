call plug#begin('~/.config/nvim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'LnL7/vim-nix'
Plug 'morhetz/gruvbox'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'

" Clojure
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'vim-scripts/paredit.vim', { 'for': 'clojure' }

call plug#end()

let mapleader = ','

" Buffers
set autoread
set hidden
set history=1000
set nobackup
set noswapfile
set nowritebackup

" UI
set number
set background=dark
set relativenumber
set completeopt-=preview

colorscheme solarized

" Whitespace
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start

" Text formatting
set nowrap
set gdefault

" Searching
set nohlsearch
set ignorecase
set smartcase
set wildmenu
set wrapscan

" Mappings
nmap ; :
nmap <CR> o<Esc>
imap <Leader>c <Esc>
vmap <Leader>c <Esc>

nmap <Leader>s :split<CR>
nmap <Leader>v :vsplit<CR>

nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k

nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>t :Files<CR>

let g:deoplete#enable_at_startup = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

autocmd FileType clojure call s:clojure_config()

function! s:clojure_config()
  let g:clojure_align_multiline_strings = 1
  let g:clojure_align_subforms = 1
  let g:paredit_electric_return = 0

  setlocal lispwords+=as->,go-loop

  nmap <buffer> <Leader>r :Require<CR>
  nmap <buffer> dge hvgelx
endfunction
