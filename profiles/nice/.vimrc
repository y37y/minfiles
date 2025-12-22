" ====================
" minfiles: nice vimrc for servers (plugins optional)
" Compatible: Ubuntu/Debian/Alpine/FreeBSD/pfSense/Proxmox
" ====================

set nocompatible
syntax on
filetype plugin indent on

" --- Security / safety ---
set noexrc
set nomodeline
set modelines=0

" --- Core ---
set encoding=utf-8
set fileencoding=utf-8
set hidden
set autoread

" Shell: prefer $SHELL, then bash, then sh
if exists('$SHELL') && executable($SHELL)
  execute 'set shell=' . $SHELL
elseif executable('/bin/bash')
  set shell=/bin/bash
else
  set shell=/bin/sh
endif

" --- UI ---
set number
set relativenumber
set ruler
set showcmd
set showmatch
set cursorline
set laststatus=2

set wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,*.pyc,__pycache__,node_modules,.git

set scrolloff=8
if exists('+sidescrolloff')
  set sidescrolloff=8
endif

set display+=lastline
set noerrorbells
set visualbell
set t_vb=
set shortmess+=I

if exists('+signcolumn')
  set signcolumn=yes
endif

if exists('+colorcolumn')
  set colorcolumn=80
endif

" Show invisible chars (toggleable)
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" --- Performance ---
set ttyfast
set lazyredraw
set timeout
set timeoutlen=500
if exists('+ttimeoutlen')
  set ttimeoutlen=10
endif
set updatetime=300
set redrawtime=10000

" --- Search ---
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan
set path+=**

" --- Indent / formatting ---
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

set wrap
set linebreak
if exists('+breakindent')
  set breakindent
endif

set textwidth=0
set formatoptions+=jnq

" --- Swap / Undo (recommended for servers) ---
silent! call mkdir(expand('~/.vim/swap'), 'p', 0700)
silent! call mkdir(expand('~/.vim/undo'), 'p', 0700)

set swapfile
set directory^=$HOME/.vim/swap//

if has('persistent_undo')
  set undofile
  set undodir^=$HOME/.vim/undo//
endif

" Backups: optional; keep off to avoid extra files on remote systems
set nobackup
set nowritebackup

" --- True color (only if supported) ---
if exists('+termguicolors')
  set termguicolors
endif
set background=dark

" --- Colorscheme: try tokyonight, fallback to built-in ---
silent! colorscheme tokyonight
if !exists('g:colors_name') || g:colors_name ==# '' || g:colors_name ==# 'default'
  silent! colorscheme slate
endif

" --- Statusline (built-in, no plugin required) ---
set statusline=%<%f\ %w%h%m%r
set statusline+=%{&ff!='unix'?'['.&ff.']':''}\ %y
set statusline+=%=
set statusline+=%{&encoding!='utf-8'?'['.&encoding.']':''}
set statusline+=\ %l/%L:%c\ %P

" --- Leader / mappings ---
let mapleader=" "

nnoremap <silent> <leader>w :silent w<CR>
nnoremap <silent> <leader>q :silent q<CR>
nnoremap <silent> <leader>x :silent x<CR>
nnoremap <silent> <leader>n :nohlsearch<CR>
nnoremap <silent> <leader><leader> :nohlsearch<CR>

nnoremap H ^
nnoremap L $
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

nnoremap <leader>li :set list!<CR>

" Split navigation + tmux integration if in tmux
if exists('$TMUX') && executable('tmux')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let prev = winnr()
    silent! execute "wincmd " . a:wincmd
    if prev == winnr()
      silent! call system("tmux select-pane -" . a:tmuxdir)
    endif
  endfunction
  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<CR>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<CR>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<CR>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<CR>
else
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
endif

" Window/buffer helpers
nnoremap <leader>ws :split<CR>
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wo :only<CR>
nnoremap <leader>we <C-w>=
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>ls :ls<CR>

" Clipboard (only if supported)
if has('clipboard') && has('unnamedplus')
  set clipboard=unnamedplus
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y
  nnoremap <leader>p "+p
  nnoremap <leader>P "+P
  nnoremap <leader>ya :%y+<CR>
endif

" Command-line QoL
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Quick edit/reload vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Common command typos
command! -bang W  w<bang>
command! -bang Q  q<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>

" --- Plugins (optional, only if installed) ---
if exists(':Files')
  nnoremap <C-p> :Files<CR>
  if exists(':Buffers')
    nnoremap <leader>b :Buffers<CR>
  endif
endif
if exists(':Rg')
  nnoremap <C-g> :Rg<CR>
endif

" --- Whitespace: scoped (avoid Makefiles / sensitive files) ---
function! s:TrimTrailingWhitespace()
  let l:view = winsaveview()
  silent! keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

augroup MinfilesNiceTrimWS
  autocmd!
  " Intentionally excludes: make, gitcommit, markdown (and anything else not listed)
  autocmd BufWritePre * if index(['sh','bash','zsh','vim','lua','python','yaml','yml','json','toml','conf','dockerfile'], &ft) >= 0 |
        \ call <SID>TrimTrailingWhitespace() |
        \ endif
augroup END

" --- Filetype tweaks ---
augroup MinfilesNiceFt
  autocmd!
  autocmd FileType yaml,yml,json,sh,bash,vim,conf,toml,dockerfile,lua setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 textwidth=79 colorcolumn=80 expandtab
  autocmd FileType markdown setlocal wrap linebreak nolist
  autocmd FileType gitcommit setlocal spell textwidth=72 colorcolumn=73
augroup END

" --- Proxmox-ish helpers (safe) ---
augroup PVEFiles
  autocmd!
  autocmd BufRead,BufNewFile /etc/pve/* set filetype=conf
  autocmd BufRead,BufNewFile *.log set filetype=messages autoread
  autocmd BufRead,BufNewFile /var/log/* set filetype=messages
augroup END

nnoremap <leader>cl :e /var/log/pveproxy/access.log<CR>
nnoremap <leader>cs :e /var/log/syslog<CR>

" --- Terminal (if supported) ---
if has('terminal')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" --- Remember last cursor position ---
augroup MinfilesLastPos
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   silent! exe "normal! g`\"" |
    \ endif
augroup END

" Folding
set foldmethod=indent
set foldlevel=99
set foldenable
nnoremap <leader>zR :set foldlevel=99<CR>
nnoremap <leader>zM :set foldlevel=0<CR>
