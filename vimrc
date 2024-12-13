" ---------------------------------------------
" My vimrc
" License MIT
"
" Credits
"   https://github.com/Happy-Dude/
"   https://github.com/bahamas10/
"   https://github.com/tpop/vim-sensible
"
" ---------------------------------------------

" Disable VI Compatibility
if &compatible
    set nocompatible
endif

" Disable modelines
set nomodeline

" ---------------------------------------------
" Vim UI Options
" ---------------------------------------------
set so=7						" 7 lines to the cursor when moving vertically

set ruler						" Show cursor line and col number
set showmatch					" Show matching brackets.
set cmdheight=1
set title						" Set the title
set foldcolumn=1				" Add margin to the left
set relativenumber				" Enable relative line numbers
set number                      " Show current line number instead of 0


" ---------------------------------------------
" Vim Status Bar Options
" ---------------------------------------------
set laststatus=1                " Show the statusline
set showmode					" Show the current mode in status line
set showcmd						" Show partial command in status line


" ---------------------------------------------
" Vim wildmenu Options
" ---------------------------------------------
set wildmenu					" Enable wildmenu (tab completion of commands)

" Ignore compiled files in wildmenu
set wildignore+=*.o,*~,*.py[cod]
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set backspace=indent,eol,start	" Backspace all characters


" ---------------------------------------------
" Vim Search Options
" ---------------------------------------------
set hlsearch					" Highlight search results
set ignorecase					" Ignore case when searching...
set smartcase					" ...Unless specified
set incsearch					" Show results as searching


" ---------------------------------------------
" Vim File Options
" ---------------------------------------------
set encoding=utf8				" utf-8 encoding
set ffs=unix,mac,dos			" set file types
set autoread                    " load changes after external command (!)


" ---------------------------------------------
" Vim Tab and Indent Options
" ---------------------------------------------
set expandtab					" Spaces instead of tabs
set smarttab					" Smart tabs
set tabstop=4					" 1 tab == 4 spaces
set shiftwidth=4				" 1 tab == 4 spaces

set lbr
"set textwidth=80				" linebreak at 80 columns

set autoindent					" Keep indent when starting newline...
set smartindent					" ...But do it intelligently
set wrap						" Wrap


" ---------------------------------------------
" Vim Color Options
" ---------------------------------------------
syntax enable					" Enable syntax highlighting
filetype plugin indent on

" true color support
" https://github.com/rakr/vim-one?tab=readme-ov-file
if has('termguicolors')
    set termguicolors
endif

try
	colorscheme one			" Set theme if available

catch /.*/
    echoerr v:exception
endtry

set background=dark			" Dark colorscheme
" Make comments more visible with transparent background
highlight Comment guifg=#cccccc ctermfg=white
highlight vimLineComment guifg=#cccccc ctermfg=white

highlight Normal ctermbg=NONE guibg=NONE " Transparent background

" highlight unwanted whitespace
highlight link RedundantWhitespace StatusLineTerm
match RedundantWhitespace /\s\+$\| \+\ze\t/

" ---------------------------------------------
" Spell Check Settings
" ---------------------------------------------
setlocal nospell spelllang=en_us	" Turn off spellcheck by default
highlight clear SpellBad
highlight SpellBad term=standout cterm=underline ctermfg=red
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline


" ---------------------------------------------
" Custom Commands/Mappings
" ---------------------------------------------
command! SC setlocal spell! spelllang=en_us    " toggle spellcheck

nnoremap Y y$
nnoremap <silent> <Esc> :noh<CR>

if has("autocmd")
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif
endif

" ---------------------------------------------
" Helper functions
" ---------------------------------------------
function! HasPaste()           " Return true if paste mode enabled
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  let g:is_posix = 1
endif

" ---------------------------------------------
" Source local config
" ---------------------------------------------
if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

