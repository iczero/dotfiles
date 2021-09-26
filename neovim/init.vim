syntax on
set number
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set backspace=indent,eol,start
set ruler
set showcmd
set mouse=a
set modeline

filetype plugin indent on

autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2

" plugins
" automatically install vim-plug
let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
    execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs ' .
                \ 'https://github.com/junegunn/vim-plug/raw/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" load plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dikiaap/minimalist'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" language server plugins
autocmd VimEnter * call coc#add_extension('coc-json', 'coc-tsserver',
            \ 'coc-pyright', 'coc-sh')

" color scheme
set t_Co=256
colorscheme minimalist
let g:airline_theme = 'minimalist'
let g:airline#extensions#tabline#enabled = 1

" color customizations
hi Normal guibg=None ctermbg=None
hi NonText guibg=None ctermbg=None
hi Pmenu guibg=#1C1C1C ctermbg=234

