call pathogen#infect('~/.vim/bundle')

sy on
set noai

syntax enable
set background=dark
colorscheme vividchalk


nmap ,t <Esc>:tabnew<CR>

if has ("autocmd")
  filetype plugin indent on
endif

if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }
endif

set ruler		" Show the line number on the bar
set more		" Use more prompt
set autoread		" Watch for file changes
set number		" Line numbers
set hidden		" Hide buffers when they are abandoned
set autowrite		" Don't automatically write on :next
set lazyredraw	" Don't redraw when don't have to
set showmode
set showcmd		" Show (partial) command in status line
set nocompatible	" vim, not vi
set backspace=indent,eol,start " Allowed to delete character before cursor
set autoindent smartindent "auto/smart indent
set smarttab	"tab and backspace are smart
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set cursorline
set scrolloff=5 "keep at least 5 lines above/below
set sidescrolloff=5 "keey at least 5 lines left/right
set cmdheight=2 "command line two lines high
set showmatch		" Show matching brackets
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set noswapfile "no swapfiles
