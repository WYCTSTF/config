filetype plugin on
syn on
set nu rnu
set ai cin
set ts=2 sw=2
set vb t_vb=
set backspace=indent,eol,start
set autoread

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

no <F5> :!clang++ -O2 -std=c++17 %:p -o %:r && %:h/%:r<CR>
no <F6> :!clang++ -O2 -std=c++17 %:p -o %:r && %:h/%:r<%:p:h/in<CR>
no <F7> :!cf test<CR>
no <F8> :!cf submit<CR>

set scrolloff=5

let mapleader=";"
nnoremap <leader>w <esc>:w<CR>

set rtp+=/opt/homebrew/opt/fzf
