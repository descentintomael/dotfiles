" Use VIM, not VI
set nocompatible
filetype off

" All hail the leader
let mapleader = ","

" Use Pathogen:
call pathogen#incubate()
call pathogen#helptags()

" ========================================================================
" Vundle stuff
" ========================================================================
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle (required)!
Plugin 'gmarik/vundle'

" My bundles
" A code completion plugin
Plugin 'Valloric/YouCompleteMe'
" A lagnuage senstive commenting plugin.  Access with cmd + /
Plugin 'tomtom/tcomment_vim'
" Git accessor for Vim, I don't use it, commenting it out
" Plugin 'tpope/vim-fugitive'
" Plugin for adding/removing surrounding quotes, parens, brackets, etc.
Plugin 'tpope/vim-surround'
" Provides highlighting and other useful things for Rails development
Plugin 'tpope/vim-rails'
" Adds in nice shortcuts like [q and ]q
Plugin 'tpope/vim-unimpaired'

Plugin 'vim-scripts/ruby-matchit'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'vim-ruby/vim-ruby'

" Adds code snippets
" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

Plugin 'taglist.vim'
Plugin 'ack.vim'
" Plugin 'altercation/vim-colors-solarized'
" Plugin for fuzzy file finding
Plugin 'kien/ctrlp.vim'
" Makes the status bar all fancy
Plugin 'bling/vim-airline'
" Color matching for parens/brackets/etc
Plugin 'kien/rainbow_parentheses.vim'
" Tomorrow color theme
Plugin 'chriskempson/vim-tomorrow-theme'
" Fall back to solarized for the terminal since tomorrow doesn't work there
Plugin 'altercation/vim-colors-solarized'
" Automatically adds matching end tag
Plugin 'endwise.vim'

" All plugins must go before this:
call vundle#end()
filetype plugin indent on

" ========================================================================
" Airline/Powerline stuff
" ========================================================================
let g:airline_powerline_fonts = 1

" ========================================================================
" Rainbow Parentheses stuff
" ========================================================================
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" ========================================================================
" Silver Searcher Configuration
" ========================================================================
" Changes the ack.vim plugin to use Silver Searcher instead
let g:ackprg = 'ag --nogroup --nocolor --column'

" ========================================================================
" Ctrl-P stuff
" ========================================================================
" Add in Ctrl-P
set runtimepath^=~/.vim/bundle/ctrlp.vim
" Set ctrl-p to leader-t because that's what I'm used to
let g:ctrlp_map='<Leader>t'
let g:ctrlp_cmd = 'CtrlP'
" Leader-b opens up CtrlP for buffers
nmap <silent> <Leader>b :CtrlPBuffer<CR>
" Move the Ctrl-P window to the top (easier with a veritcal monitor
let g:ctrlp_match_window = 'top,order:btt,min:1,max:10,results:10'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|sql)$'
  \ }

" Re-map '; to Esc because I like that
inoremap '; <Esc>
vnoremap '; <Esc>
nnoremap '; :w<CR>

" ---------------------
" -- UltiSnips Setup
" ---------------------
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ---------------------
" -- Add Pry Shortcuts
" ---------------------
nmap <silent> <leader>b Obinding.pry<Esc>

" --------------------
" -- VIMRC MANAGEMENT
" --------------------
" Edit vimrc
nmap <silent> <leader>ev :tabe $MYVIMRC<CR>
" Reload vimrc
nmap <silent> <leader>sv :so $MYVIMRC<CR>

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
" Turn off new line commenting (as in if this line is a comment, so is the
" next one
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

nmap <silent> <D-/> :TComment<CR>
vmap <silent> <D-/> :TComment<CR>

" --------------------
" -- HISTORY
" --------------------
set history=500
" Don't need to go nuts with the undo level, 150 should be fine
set undolevels=150
" Save text state between reloads (e.g. if you use :e!)
set undoreload=200
" OMG! Save undo levels between sessions! *fangirl squeel*
set undodir=$HOME/.vim/undo

" --------------------
" -- INTERFACE
" --------------------
syntax enable " enable syntax highlighting and allow custom highlighting
if &term=~'xterm'
  set background=dark
  colorscheme solarized
else
  colorscheme Tomorrow-Night " Set the color scheme to a pale blue
endif
set title " set the title to the file name and modification status
set number
set relativenumber " show the line numbers relative to current position
set ruler " always show the current position
set showcmd " show the command being typed
set showmode " show current mode (insert, visual, etc.)
set laststatus=2 " always show status line 
set colorcolumn=80 " Highlight column 80 so I know when to wrap
" Change the 80th char column to be grey instead of red
autocmd ColorScheme * highlight ColorColumn guibg=Gray20
set guifont=Sauce\ Code\ Powerline\ Light:h12

function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set number
    set relativenumber
  endif
endfunc

" Toggle between relative numbers and absolute numbers
nnoremap <Leader>n :call NumberToggle()<cr>

" --------------------
" -- SEARCHING 
" --------------------
set ignorecase " ignore case when searching
set smartcase " case sensitive only when capital letter in expression
set incsearch " show matches as they are found
set tags=./tags; " The tags file will always be in the current folder

" Toggle search highlighting
nnoremap <Leader>h :set hlsearch! hlsearch?<CR>
" Quickly pull up ack
nnoremap <Leader>a :Ack --ruby <C-r><C-w>
nnoremap <Leader>A :Ack --ruby 

" --------------------
" -- FEEDBACK 
" --------------------
set showmatch " show matching brace when they are typed or under cursor
set matchtime=2 " length of time for 'showmatch'
set cursorline

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
" Tab navigation setup - press cmd+N to go to tab N
nnoremap <D-1> 1gt
nnoremap <D-2> 2gt
nnoremap <D-3> 3gt
nnoremap <D-4> 4gt
nnoremap <D-5> 5gt
nnoremap <D-6> 6gt
nnoremap <D-7> 7gt
nnoremap <D-8> 8gt
nnoremap <D-9> 9gt

" Re-map ctrl-w+nav to remove the middle ctrl-w
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

noremap <C-J> <C-w>J
noremap <C-K> <C-w>K
noremap <C-L> <C-w>L
noremap <C-H> <C-w>H

" Make line navigation work the way I think it should work regardless of
" wrapping
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

" Switch between the last two files
" Thank you ThoughtBot!!! http://bit.ly/1AmdDMa
nnoremap <leader><leader> :w<CR><c-^>

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
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.sql,*.log

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
map <C-n> :call RenameFile()<cr>

" Display extra whitespace
set list listchars=tab:»·,trail:·

" ========================================================================
" End of things set by me.
" ========================================================================

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
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
