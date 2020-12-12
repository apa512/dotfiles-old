call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'LnL7/vim-nix'
Plug 'morhetz/gruvbox'
Plug 'mustache/vim-mustache-handlebars'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

" Clojure
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'vim-scripts/paredit.vim', { 'for': 'clojure' }

call plug#end()

set exrc
set secure

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

let g:ale_fix_on_save = 1
let g:ale_linters = {'clojure': ['clj-kondo'], 'haskell': ['hlint'], 'ruby': ['standardrb']}
let g:ale_fixers = {'ruby': ['standardrb']}

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})

let g:airline_theme='solarized'

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd FileType * setlocal formatoptions-=cro

autocmd FileType clojure call s:clojure_config()

function! s:clojure_config()
  let g:clojure_align_multiline_strings = 1
  let g:clojure_align_subforms = 1
  let g:paredit_electric_return = 0

  setlocal lispwords+=as->,go-loop

  nmap <buffer> <Leader>r :Require<CR>
  nmap <buffer> dge hvgelx
endfunction
