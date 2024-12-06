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
set background=light			" Light background
syntax enable					" Enable syntax highlighting

try
	colorscheme torte			" Set theme if available
catch
endtry

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif


" ---------------------------------------------
" Highlight Unwanted Whitespace
" ---------------------------------------------
highlight RedundantWhitespace ctermbg=green guibg=green
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
nnoremap <Esc> :noh<CR>

"command Vterm vertical term

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

