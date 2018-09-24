set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=/Users/`whoami`/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" leader stuff
let mapleader = ","
nmap <leader>p <Esc>:set paste<CR>
nmap <leader>' <Esc>:noh <CR>

nmap <leader>s <Esc>:w <CR>
imap <leader>s <Esc>:w <CR>

":colorscheme evening

" setup tabbing
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" ControlP
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode = 0
set wildignore+=*/tmp/*,*tests/js-test-driver/*,*/dist/*
nmap <leader>t :CtrlP<CR>
nmap <leader>r :CtrlPMRU<CR>
set autowriteall


" NERDTree stuff
let g:NERDTreeDirArrows=0
nmap ,n :NERDTreeFind<CR>
nmap <leader>ne :NERDTreeToggle<cr>

" add resolve paths
" make gf over a path or class take you there
set path+=~/development/Etsyweb/phplib/EtsyModel,~/development/Etsyweb/phplib,~/development/Etsyweb/templates/,~/development/Etsyweb/htdocs/assets/js/,~/development/Etsyweb/htdocs/
set includeexpr=substitute(v:fname,'_','/','g').'.php'
set suffixesadd=.tpl
set suffixesadd=.js

" Remove trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre *.php,*.mustache,*.tpl,*.rb,*.py,*.js :call <SID>StripTrailingWhitespaces()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Alt escape
inoremap jj <Esc>
inoremap kj <Esc>

" Add syntax highlighting
syntax on
au BufRead,BufNewFile *.mustache set filetype=html  " add mustache to html filetype
filetype plugin on
filetype plugin indent on

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Use ack for grep
set grepprg=ack

set showmode
set showcmd                " Show (partial) command in status line
set nu

set cursorline
set scrolloff=5            "keep at least 5 lines above/below
set sidescrolloff=5        "keey at least 5 lines left/right
set cmdheight=2            "command line two lines high
set showmatch              " Show matching brackets
set ignorecase             " Do case insensitive matching
set smartcase              " Do smart case matching
set incsearch              " Incremental search

nnoremap <CR> :nohlsearch<cr>
