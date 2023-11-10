set nocompatible
syn on
filetype plugin on
set undofile
set undodir=~/.vim/undodir
set path+=**
set wildmenu
set expandtab
set splitbelow
set splitright
set nu rnu
set ai cin
set ts=2 sw=2
set vb t_vb=
set backspace=indent,eol,start
set autoread
set tags=./tags;,tags

call plug#begin('~/.vim/plugged')
" Shorthand notation for plugin
Plug 'ludovicchabant/vim-gutentags'
Plug 'liuchengxu/space-vim-dark'
Plug 'yianwillis/vimdoc'
call plug#end()

" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = 'tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+lpx']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+lpx']


" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

colorscheme space-vim-dark
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

set scrolloff=5

let mapleader=";"
nmap  <C-w>h
nmap  <C-w>j
nmap  <C-w>k
nmap  <C-w>l
