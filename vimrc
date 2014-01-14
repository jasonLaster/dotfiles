execute pathogen#infect()

" leader stuff
let mapleader = ","
nmap <leader>p <Esc>:set paste<CR>
nmap <leader>' <Esc>:noh <CR>

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

" NERDTree stuff
let g:NERDTreeDirArrows=0
nmap <leader>ne :NERDTree<cr>

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


" Alt escape
inoremap jj <Esc>

" Add syntax highlighting
syntax on
au BufRead,BufNewFile *.mustache set filetype=html  " add mustache to html filetype
filetype plugin on
filetype plugin indent on


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

