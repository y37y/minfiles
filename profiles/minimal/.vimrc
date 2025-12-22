" ====================
" minfiles: minimal vimrc for servers (no plugins required)
" Safe defaults: swap ON, undo ON if available, minimal surprises
" ====================

set nocompatible
syntax on
filetype plugin indent on

" --- Encoding ---
set encoding=utf-8
set fileencoding=utf-8

" --- Safety ---
set noexrc
set nomodeline
set modelines=0

" --- Shell (prefer $SHELL, then bash, then sh) ---
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
set wildmenu
set laststatus=2
set signcolumn=yes
set noerrorbells
set visualbell
set t_vb=
set scrolloff=6

" --- Buffers ---
set hidden
set autoread

" --- Indent ---
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

" --- Search ---
set incsearch
set hlsearch
set ignorecase
set smartcase
set path+=**

" --- Swap / Undo (recommended for servers) ---
silent! call mkdir(expand('~/.vim/swap'),   'p', 0700)
silent! call mkdir(expand('~/.vim/undo'),   'p', 0700)

" Keep swap ON; helps recover if SSH drops
set swapfile
set directory^=$HOME/.vim/swap//

" Persistent undo if supported
if has('persistent_undo')
  set undofile
  set undodir^=$HOME/.vim/undo//
endif

" Backups: optional; keep off to avoid extra files on remote systems
set nobackup
set nowritebackup

" Perf-ish
set updatetime=300
set redrawtime=10000

" --- Leader ---
let mapleader=" "

" --- Quick ops ---
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>n :nohlsearch<CR>

" Split nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clipboard (only if supported)
if has('clipboard') && has('unnamedplus')
  set clipboard=unnamedplus
  vnoremap <leader>y "+y
  nnoremap <leader>p "+p
  nnoremap <leader>P "+P
endif

" Show invisibles (toggle)
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
nnoremap <leader>li :set list!<CR>

" Truecolor (if supported)
if exists('+termguicolors')
  set termguicolors
endif

" Colorscheme: optional; fallback to built-in
silent! colorscheme tokyonight
if !exists('g:colors_name') || g:colors_name ==# '' || g:colors_name ==# 'default'
  silent! colorscheme slate
endif

" --- Whitespace: ONLY for safe filetypes (avoid Makefile/tab breakage) ---
function! s:TrimTrailingWhitespace()
  let l:view = winsaveview()
  silent! keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

augroup MinfilesTrimWS
  autocmd!
  " Safe-ish: add/remove as you like
  autocmd BufWritePre * if index(['sh','bash','zsh','vim','lua','python','yaml','yml','json','toml','conf','dockerfile'], &ft) >= 0 |
        \ call <SID>TrimTrailingWhitespace() |
        \ endif
augroup END

" --- Filetype tweaks ---
augroup MinfilesFt
  autocmd!
  autocmd FileType yaml,yml,json,sh,bash,vim,lua,toml,conf,dockerfile setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType markdown setlocal wrap linebreak nolist
augroup END

" Remember cursor position
augroup MinfilesLastPos
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END
