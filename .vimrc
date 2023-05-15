set nocompatible
filetype plugin on
syn on
set rnu
set ts=2 sw=2
set ai cin
set vb t_vb=
set backspace=indent,eol,start

" 快速文件搜索|模糊查询
set path+=**
set wildmenu

set is " incsearch, useful for replacing

" usually not required, only for some terminal with bad highlighting
hi Search ctermbg=red
hi Search ctermfg=white

let g:netrw_banner=0
let g:netrw_winsize=25
let g:netrw_liststyle=3
let g:netrw_altv=1
let g:netrw_browse_split=4

set makeprg=ninja

no <F5> :!clear && clang++ -O2 -std=c++17 %:p -o %:r && %:h/%:r<CR>
no <F6> :!clear && clang++ -O2 -std=c++17 %:p -o %:r && %:h/%:r<%:p:h/in<CR>
no <F7> :!clear && cd %:p/build && ninja && ./sol<CR>
no <F8> :!clear && cd %:p/build && ninja && ./sol<%:p:h/in<CR>

set scrolloff=5
