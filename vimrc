" Use VIM, not VI
set nocompatible
filetype off

" Use Pathogen:
call pathogen#incubate()
call pathogen#helptags()

" ========================================================================
" Vundle stuff
" ========================================================================
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle (required)!
Bundle 'gmarik/vundle'

" My bundles
Bundle 'ervandew/supertab'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-ruby/vim-ruby'
Bundle 'wincent/Command-T'
Bundle 'vim-scripts/ruby-matchit'
Bundle 'thoughtbot/vim-rspec'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"


let mapleader = ","

inoremap '; <Esc>
vnoremap '; <Esc>

" --------------------
" -- EDITING
" --------------------
" Make backspace work like normal text editors
set backspace=start,indent,eol
set autoindent
set autoread
set smarttab
set tabstop=2
set shiftwidth=2
set gdefault " Make search/replace global by default

" --------------------
" -- HISTORY
" --------------------
set history=500
set undolevels=75

" --------------------
" -- INTERFACE
" --------------------
syntax enable " enable syntax highlighting and allow custom highlighting
set background=dark " Use the dark variant of my theme
colorscheme solarized
set title " set the title to the file name and modification status
set rnu " show the line numbers relative to current position
set ruler " always show the current position
set showcmd " show the command being typed
set showmode " show current mode (insert, visual, etc.)
set laststatus=2 " always show status line 
set wildmenu

" --------------------
" -- SEARCHING 
" --------------------
set ignorecase " ignore case when searching
set smartcase " case sensitive only when capital letter in expression
set hlsearch " highlight search terms
set incsearch " show matches as they are found

" --------------------
" -- FEEDBACK 
" --------------------
set showmatch " show matching brace when they are typed or under cursor
set matchtime=2 " length of time for 'showmatch'

" --------------------
" -- REDRAW / WARNINGS 
" --------------------
set lazyredraw " Don't redraw the screen when executing macros
set noerrorbells " No bell for error messages
set visualbell " Use whatever 't_vb' is set to as the bell
set t_vb=  " Set the visual bell to nothing for now TODO: Fill in later

" Restore 't_vb" since it is reset after GUI startup
if has("gui_running")
    augroup disable_gui_visual_bell
        autocmd!
        autocmd GUIEnter * set t_vb=
    augroup end
endif

" --------------------
" -- NAVIGATION 
" --------------------
set scrolloff=5 " Start scrolling the window 5 lines before the edge of the window
set sidescrolloff=5

" --------------------
" -- MOUSE INPUT 
" --------------------
set mouse=a " enable mouse support

" --------------------
" -- ENCODING 
" --------------------
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1 " Encodings to look for when loading files.

" --------------------
" -- FILES
" --------------------
set autowrite " Automatically save the file when I look away


" --------------------
" -- COLORING
" --------------------

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<SID>
function! <SID>SynStack()
  if !exists("*synstack")
  	return
  endif
  echo map(synstack(line('.'),col('.')), 'syndIDattr(v:val, "name")')
endfunc



" Set the tag file search order
set tags=./tags;

" Use _ as a word-separator
 set iskeyword-=_,#

" Use Silver Searcher instead of grep
set grepprg=ag

" Make the omnicomplete text readable
:highlight PmenuSel ctermfg=black

" Fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

" Highlight the status line
highlight StatusLine ctermfg=blue ctermbg=yellow

" Format xml files
au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null" 

set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

set nofoldenable " Say no to code folding...

command! Q q " Bind :Q to :q
command! Qall qall 


" Disable Ex mode
map Q <Nop>

" Disable K looking stuff up
map K <Nop>

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal wrap 
au BufNewFile,BufRead *.txt setlocal lbr

" Better? completion on command line
set wildmenu
" What to do when I press 'wildchar'. Worth tweaking to see what feels right.
set wildmode=list:full

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1

" Turn on spell-checking in markdown and text.
" au BufRead,BufNewFile *.md,*.txt setlocal spell

" Merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  split
  execute "buffer " . bufferName
endfunction

nmap <C-W>u :call MergeTabs()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Test-running stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rspec.vim mappings
map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <Tab> <C-P>

" Let's be reasonable, shall we?
nmap k gk
nmap j gj


" Don't add the comment prefix when I hit enter or o/O on a comment line.
set formatoptions-=or

let g:CommandTMaxHeight=50
let g:CommandTMatchWindowAtTop=1

" Don't wait so long for the next keypress (particularly in ambigious Leader
" situations.
set timeoutlen=500


function! OpenFactoryFile()
  if filereadable("test/factories.rb")
    execute ":sp test/factories.rb"
  else
    execute ":sp spec/factories.rb"
  end
endfunction

" Set gutter background to black
highlight SignColumn ctermbg=black

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <Leader>n :call RenameFile()<cr>

" Display extra whitespace
set list listchars=tab:»·,trail:·

" ========================================================================
" End of things set by me.
" ========================================================================

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

  " ================
  " Ruby stuff
  " ================
  syntax on                 " Enable syntax highlighting

  augroup myfiletypes
  	" Clear old autocmds in group
  	autocmd!
  	" autoindent with two spaces, always expand tabs
  	autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
  augroup END
  " ================
endif " has("autocmd")
