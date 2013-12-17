execute pathogen#infect()
syntax on
filetype plugin indent on

let mapleader = ","
nmap <leader>ne :NERDTree<cr>


" setup tabbing
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab


" vim window tabs
imap ,t <Esc>:tabnew<CR>

filetype plugin on

function! NumberToggle()
  if(&relativenumber == 1)
    set nonu
    set nornu
  else
    set rnu 
    set nu
  endif
endfunc

set nu
set rnu
nnoremap <C-n> :call NumberToggle()<cr>
