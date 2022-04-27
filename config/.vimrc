" ---- dot vimrc ----
" Author: TJ Maynes <tj at tjmaynes dot com>
" Website: https://tjmaynes.com/


" Default Configuration

set nocompatible                    "work with old systems
set encoding=utf-8                  "utf-8, please

set lazyredraw                      "no lag, please
set ttyfast
set synmaxcol=300

set backspace=indent,eol,start      "unix solution
set showmatch
set showcmd                         "shows what commands are available
set hlsearch                        "highlight search results
set incsearch                       "incremental search
set novisualbell                    "no yellin'

set linespace=0
set history=100                     "histoy of old commands run
set antialias
set autowrite                       "write before running commands
set autochdir                       "start vim in current directory
set hidden
set autoread

set nonumber
set modeline
set wildmenu
set wildmode=longest,list,full
set completeopt+=longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,node_modules,Carthage,_site,vendor,*.pyc,venv
set omnifunc=syntaxcomplete#Complete

set directory=~/.vim/tmp            " don't litter my drive with .swp files
set backupdir=~/.vim/backup         " put backup files in .vim directory
silent execute '!mkdir -p ~/.vim/tmp'
silent execute '!mkdir -p ~/.vim/backup'

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set foldmethod=indent
set foldlevel=99

if has("gui_running")
  set fuoptions=maxvert,maxhorz
  set transparency=3
  set guifont=Inconsolata:h16
  set guioptions-=L
  set guioptions-=r
endif

nnoremap <C-n> :bnext<cr>
nnoremap <C-p> :previous<cr>
nmap <silent> <leader>w :w!<cr>
nmap <silent> <leader>. :tabnext<cr>
nmap <silent> <leader>/ :tabnext<cr>
nmap <silent> <leader>q :r! date +"\%Y-\%m-\%d \%H:\%M:\%S"<cr>

"split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"folding
nnoremap <space> za

" Language support

autocmd BufNewFile,BufRead .babelrc setf json
autocmd BufNewFile,BufRead *.fountain set filetype=fountain

autocmd BufNewFile,BufRead *.py
      \ set tabstop=4 |
      \ set softtabstop=4 |
      \ set shiftwidth=4 |
      \ set textwidth=79 |
      \ set expandtab |
      \ set autoindent |
      \ set fileformat=unix

autocmd BufNewFile,BufRead *.js, *.html, *.css
      \ set tabstop=2 |
      \ set softtabstop=2 |
      \ set shiftwidth=2


" Packages

call plug#begin('~/.vim/plugged')

Plug 'jnurmine/Zenburn'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jamessan/vim-gnupg'
Plug 'editorconfig/editorconfig-vim'

Plug 'kblin/vim-fountain'
Plug 'tpope/vim-markdown'
Plug 'junegunn/goyo.vim'

Plug 'LnL7/vim-nix'

Plug 'ekalinin/Dockerfile.vim'

Plug 'fatih/vim-go'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'

Plug 'vim-python/python-syntax'

Plug 'elzr/vim-json'
Plug 'digitaltoad/vim-pug'
Plug 'cespare/vim-toml'

call plug#end()

" Development

set background=dark
silent! syntax enable
silent! colorscheme zenburn

filetype indent on

let g:jsx_ext_required = 0

" NERDTree support

let NERDTreeIgnore=['\.pyc$', '\~$']
let NERDTreeQuitOnOpen=0
let NERDTreeDirArrows=1
let NERDTreeMinimalUI=1

map <silent> <leader>d :execute 'NERDTreeToggle ' . getcwd()<cr>
map <silent> <leader>b :NERDTreeFromBookmark<cr>

" Syntastic support

let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": ["python"]}

map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5

" Goyo support

map <silent> <leader>g :Goyo<cr>

" Pretty JSON

command PyJSONPretty execute "%!python -m json.tool"
nnoremap <leader>j :PyJSONPretty<cr>
