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
set hidden
set updatetime=500

filetype plugin indent on

autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2

" plugins
" automatically install vim-plug
let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
    execute '!curl -vfLo ' . data_dir . '/autoload/plug.vim --create-dirs ' .
                \ 'https://github.com/junegunn/vim-plug/raw/master/plug.vim'
    execute 'source ' . data_dir . '/autoload/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" load plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dikiaap/minimalist'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-markdown'
call plug#end()

" language server plugins
autocmd VimEnter * call coc#add_extension('coc-json', 'coc-tsserver',
            \ 'coc-pyright', 'coc-sh', 'coc-rust-analyzer', 'coc-clangd')

" color scheme
set t_Co=256
colorscheme minimalist
let g:airline_theme = 'minimalist'

" other option customizations
let g:airline#extensions#tabline#enabled = 1
" less false positives for mixed-indent
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" color customizations
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi Pmenu guibg=#1C1C1C ctermbg=234
hi diffAdded guifg=green ctermfg=green
hi diffRemoved guifg=red ctermfg=red
hi Comment guifg=#808080 ctermfg=245
hi CocHighlightText guibg=#268ab5 ctermbg=24

" keybindings
" trigger completion
inoremap <silent><expr> <C-space> coc#refresh()
" tab to accept completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"
" use ctrl-p for fzf
noremap <C-p> :Buffers<cr>
noremap <C-M-p> :GFiles<cr>
" goto
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" rename
nmap <leader>rn <Plug>(coc-rename)

" coc highlight
autocmd CursorHold * silent call CocActionAsync('highlight')

" show documentation
function! s:show_documentation()
    if (coc#rpc#ready())
        call CocActionAsync('doHover')
    endif
endfunction
noremap <silent> K :call <SID>show_documentation()<CR>

" load local configuration if exists
if filereadable(stdpath('config') . '/local.vim')
    exe 'source' stdpath('config') . '/local.vim'
endif

