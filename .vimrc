" ====================
" Ultimate Cross-Platform Server vimrc
" Compatible with: Linux, BSD, MacOS, Solaris
" Tested on: Ubuntu, Debian, Alpine, FreeBSD, pfSense, PVE
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
set shellslash
set shell=/bin/sh
if executable('/bin/bash')
    set shell=/bin/bash
endif

" --- System Integration ---
if has('clipboard')
    if has('unnamedplus')
        set clipboard^=unnamed,unnamedplus
    else
        set clipboard^=unnamed
    endif
endif

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
set number relativenumber     " Line numbers + relative
set ruler showcmd showmatch
set cursorline                " Highlight current line
set laststatus=2 wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,*.pyc,__pycache__,node_modules,.git
set scrolloff=8 sidescrolloff=8
set display+=lastline
set noerrorbells visualbell t_vb=
set shortmess+=I
set list listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set signcolumn=yes
set colorcolumn=80            " Column guide

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

" --- Colorscheme Settings ---
set background=dark
set termguicolors

let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 0
let g:tokyonight_menu_selection_background = 'green'
let g:tokyonight_disable_italic_comment = 0

" Theme switching commands
command! Night let g:tokyonight_style = 'night' | colorscheme tokyonight
command! Storm let g:tokyonight_style = 'storm' | colorscheme tokyonight
command! Dark colorscheme tokyonight

" Set colorscheme with fallback
try
    colorscheme tokyonight
catch
    colorscheme desert
endtry

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

" Tmux true color and cursor support
if exists('$TMUX')
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
    endif
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
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
nnoremap <silent> <leader><leader> :nohlsearch<CR>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv

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
    nnoremap <leader>y "+y
    nnoremap <leader>p "+p
    nnoremap <leader>P "+P
    nnoremap <leader>ya :%y+<CR>
endif

" Command mode improvements
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" Quick settings
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Common command aliases
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>

" --- Plugin Settings (if installed) ---
" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=0
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" FZF
set rtp+=~/.fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme='tokyonight'
let g:airline#extensions#tabline#enabled = 1

" --- File Type Settings ---
augroup FileTypeSpecific
    autocmd!
    autocmd FileType yaml,yml,json,sh,bash,vim,conf,toml,dockerfile
        \ setlocal ts=2 sts=2 sw=2
    autocmd FileType python
        \ setlocal ts=4 sts=4 sw=4 textwidth=79 colorcolumn=80
    autocmd FileType markdown
        \ setlocal wrap linebreak nolist
    autocmd FileType gitcommit
        \ setlocal spell textwidth=72 colorcolumn=73
    autocmd BufWritePre *
        \ silent! %s/\s\+$//e
augroup END

" --- PVE-Specific Settings ---
augroup PVEFiles
    autocmd!
    autocmd BufRead,BufNewFile /etc/pve/* set filetype=conf
    autocmd BufRead,BufNewFile *.conf set filetype=conf
    autocmd BufRead,BufNewFile *.log set filetype=messages autoread
    autocmd BufRead,BufNewFile /var/log/* set filetype=messages
augroup END

" PVE quick access
nnoremap <leader>cl :e /var/log/pveproxy/access.log<CR>
nnoremap <leader>cs :e /var/log/syslog<CR>
nnoremap <leader>cc :e /etc/pve/<CR>

" --- Terminal Settings ---
if has('terminal')
    tnoremap <Esc> <C-\><C-n>
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
set foldmethod=indent
set foldlevel=99
set foldenable
nnoremap <leader>zR :set foldlevel=99<CR>
nnoremap <leader>zM :set foldlevel=0<CR>

" --- End of Configuration ---
