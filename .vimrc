" ====================
" Ultimate Cross-Platform Server vimrc
" Compatible with: Linux, BSD, MacOS, Solaris
" Tested on: Ubuntu, Debian, Alpine, FreeBSD, pfSense, PVE
" Features:
" - Enhanced security defaults
" - Cross-platform compatibility
" - Optimized performance
" - Smart error handling
" - Robust system integration
" ====================

" --- Security Settings ---
set secure                     " Restrict autocmd in vimrc
set modelines=0               " Disable modelines (security)
set viminfofile=NONE          " Don't create viminfo file
set nobackup noswapfile nowritebackup  " No backup/swap files
set history=1000             " Keep command history

" --- Core Settings ---
set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8 fileencoding=utf-8
set autoread hidden           " Better buffer handling
set ttyfast lazyredraw       " Performance optimization

" --- Error Handling ---
" Safer external commands
set shellslash
set shell=/bin/sh
if executable('/bin/bash')
    set shell=/bin/bash
endif

" --- System Integration ---
" Cross-platform clipboard support
if has('clipboard')
    if has('unnamedplus')
        set clipboard^=unnamed,unnamedplus
    else
        set clipboard^=unnamed
    endif
endif

" Universal mouse support
if has('mouse')
    set mouse=a
    if &term =~ '^screen\\|^tmux'
        if has('mouse_sgr')
            set ttymouse=sgr
        else
            set ttymouse=xterm2
        endif
    endif
endif

" --- UI Configuration ---
set number ruler showcmd showmatch
set laststatus=2 wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,*.pyc,__pycache__,node_modules,.git
set scrolloff=4 sidescrolloff=8
set display+=lastline
set noerrorbells visualbell t_vb=
set shortmess+=I
set list listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set signcolumn=yes

" --- Performance Settings ---
set timeout timeoutlen=500 ttimeoutlen=10
set updatetime=300 redrawtime=10000

" --- Search Settings ---
set incsearch hlsearch
set ignorecase smartcase
set path+=**
set wrapscan

" --- Indentation and Formatting ---
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set autoindent smartindent
set wrap linebreak breakindent
set textwidth=0
set formatoptions+=jnq

" --- Status Line ---
set statusline=%<%f\                     " Filename
set statusline+=%w%h%m%r                 " Flags
set statusline+=%{&ff!='unix'?'['.&ff.']':''} " File format
set statusline+=%y                       " File type
set statusline+=%=                       " Right align
set statusline+=%{&encoding!='utf-8'?'['.&encoding.']':''} " Encoding
set statusline+=\ %l/%L:%c\ %P          " Position

" --- Key Mappings ---
let mapleader=" "

" Fast operations
nnoremap <silent> <leader>w :silent w<CR>
nnoremap <silent> <leader>q :silent q<CR>
nnoremap <silent> <leader>x :silent x<CR>

" Smart tmux integration
if exists('$TMUX')
    function! TmuxOrSplitSwitch(wincmd, tmuxdir)
        let previous_winnr = winnr()
        silent! execute "wincmd " . a:wincmd
        if previous_winnr == winnr()
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

" Tmux-specific settings
if exists('$TMUX')
    " True color support
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
    endif
    
    " Cursor shapes
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
    
    " Window title
    let &t_ts = "\<Esc>]2;"
    let &t_fs = "\007"
    
    augroup TmuxIntegration
        autocmd!
        autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * 
            \ silent! call system("tmux rename-window " . expand("%:t"))
        autocmd VimLeave * 
            \ silent! call system("tmux setw automatic-rename")
    augroup END
endif

" Window/Buffer management
nnoremap <leader>ws :split<CR>
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wo :only<CR>
nnoremap <leader>we <C-w>=
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>ls :ls<CR>

" Search and navigation
nnoremap <silent> <leader>n :nohlsearch<CR>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" Text manipulation
nnoremap H ^
nnoremap L $
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

" Clipboard operations
if has('clipboard')
    vnoremap <leader>y "+y
    vnoremap <leader>Y "+Y
    nnoremap <leader>y "+y
    nnoremap <leader>Y "+Y
    nnoremap <leader>p "+p
    nnoremap <leader>P "+P
    vnoremap <leader>p "+p
    vnoremap <leader>P "+P
    nnoremap <leader>ya :%y+<CR>
endif

" Command mode improvements
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-b> <S-Left>
cnoremap <C-w> <S-Right>

" Quick settings
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Common command aliases
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>

" --- File Type Settings ---
augroup FileTypeSpecific
    autocmd!
    " Common config files
    autocmd FileType yaml,yml,json,sh,bash,vim,conf,toml,dockerfile 
        \ setlocal ts=2 sts=2 sw=2

    " Language specific
    autocmd FileType python 
        \ setlocal ts=4 sts=4 sw=4 textwidth=79 colorcolumn=80
    autocmd FileType markdown 
        \ setlocal wrap linebreak nolist
    autocmd FileType gitcommit 
        \ setlocal spell textwidth=72 colorcolumn=73

    " System files
    autocmd BufNewFile,BufRead {*.conf,*/pve/*,*/systemd/*,*/nginx/*,*/sites-*/*}
        \ setlocal ft=conf
    autocmd BufNewFile,BufRead */prometheus/*,*/grafana/* 
        \ setlocal ft=yaml
    autocmd BufNewFile,BufRead /etc/fstab 
        \ setlocal ft=fstab
    autocmd BufNewFile,BufRead */supervisord/* 
        \ setlocal ft=dosini

    " Auto cleanup
    autocmd BufWritePre * 
        \ silent! %s/\s\+$//e
augroup END

" --- Terminal Settings ---
if has('terminal')
    augroup TerminalSettings
        autocmd!
        autocmd TerminalOpen * setlocal nonumber norelativenumber
        autocmd BufEnter term://* startinsert
    augroup END
    
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
endif

" --- Persistent Undo ---
if has('persistent_undo')
    let &undodir = expand('~/.vim/undo')
    if !isdirectory(&undodir)
        silent! call mkdir(&undodir, 'p', 0700)
    endif
    set undofile
endif

" --- Remember Last Position ---
augroup LastPosition
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   silent! exe "normal! g`\"" |
        \ endif
augroup END

" --- Folding Settings ---
set foldmethod=indent    " Fold based on indentation
set foldlevel=99         " Open all folds by default
set foldenable           " Enable folding

" Folding shortcuts
nnoremap <leader>zR :set foldlevel=99<CR>   " Open all folds
nnoremap <leader>zM :set foldlevel=0<CR>    " Close all folds

" Custom remappings for folding
nnoremap zA zR           " Remap zA to open all folds
nnoremap zC zM           " Remap zC to close all folds

" --- End of Configuration ---
