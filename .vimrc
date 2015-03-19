"----------------------------------------------------------------------------
"                          __
"                  __  __ /\_\    ___ ___   _ __   ___
"                 /\ \/\ \\/\ \ /' __` __`\/\`'__\/'___\
"                __\ \ \_/ |\ \ \/\ \/\ \/\ \ \ \//\ \__/
"               /\_\\ \___/  \ \_\ \_\ \_\ \_\ \_\\ \____\
"               \/_/ \/__/    \/_/\/_/\/_/\/_/\/_/ \/____/
"
" This .vimrc file uses folding to manage the display of its contents.
" Use the 'zR' command to open all of the sections if you're lost...
" ----------------------------------------------------------------------------
" Plugins                                                                  {{{
" ----------------------------------------------------------------------------
" This is where you put all your github-sourced vim plugins
" Run ':PluginInstall' to install them
" Run ':PluginClean' to remove unused plugins

set nocompatible              " required, use modern vim features
filetype off                  " required, for the Vundle setup part. Re-enabled later.

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'            " Required for this to work
Plugin 'dougireton/vim-chef'          " chef linting
Plugin 'beeerd/vim-chef-goto'         " chef go-to-file support
Plugin 'MarcWeber/vim-addon-mw-utils' " Dependency for beeerd/vim-chef-snippets
Plugin 'tomtom/tlib_vim'              " Dependency for beeerd/vim-chef-snippets
Plugin 'garbas/vim-snipmate'          " Dependency for beeerd/vim-chef-snippets
Plugin 'beeerd/vim-chef-snippets'     " Handy chef snippets and highlighting
Plugin 'kchmck/vim-coffee-script'     " coffee-script highlighting
Plugin 'pangloss/vim-javascript'      " javascript highlighting
Plugin 'elzr/vim-json'                " json highlighting
Plugin 'tpope/vim-markdown'           " markdown highlighting
Plugin 'vim-ruby/vim-ruby'            " ruby highlighting
Plugin 'tpope/vim-rails'              " rails highlighting
Plugin 'avakhov/vim-yaml'             " yaml highlighting
Plugin 'godlygeek/tabular'            " quick regex based formatting (v-mode highlight ':Tab /<pattern>')
Plugin 'tpope/vim-surround'           " quick shortcuts for delimiters
Plugin 'scrooloose/nerdtree'          " file tree navigator (n)
Plugin 'tomtom/tcomment_vim'          " add shortcut for commenting ('g-c-c')
Plugin 'taylor/vim-zoomwin'           " zoom in on a split pane (ctrl+w-o)
Plugin 'scrooloose/syntastic'         " linter
Plugin 'mileszs/ack.vim'              " Ack-find from within vim (:Ack <pattern>)
Plugin 'Yggdroot/indentLine'          " Sublime-like vertical guide lines
Plugin 'thoughtbot/pick.vim'          " Fuzzy-finder requires `brew tap thoughtbot/formulae ; brew install pick`
Plugin 'sjl/gundo.vim'                " Mega Undo: graphical tree-based undo menu
Plugin 'bling/vim-airline'            " Fancy status line
Plugin 'tpope/vim-fugitive'           " Git integration
Plugin 'chriskempson/base16-vim'      " Lots of color schemes

call vundle#end()            " required

" Set up Pathogen Bundle Mangement
call pathogen#infect()
call pathogen#helptags()

" }}}-------------------------------------------------------------------------
" General/Misc                                                             {{{
" ----------------------------------------------------------------------------

set hidden        " hide buffers so we don't have to write them when working on another file
set lazyredraw    " redraw only when we need to.
set history=1000  " remember past 1000 commands
set ttyfast       " Indicates a fast terminal connection
let mapleader="," " for various shortcuts later

" }}}-------------------------------------------------------------------------
" Command Line                                                            {{{
" ----------------------------------------------------------------------------

set cmdheight=1                " how tall is command line
set wildmenu                   " Enable menu during command tab completion
set wildmode=longest:full,full " 1st tab = longest commong string, subsequent show possible full matches
set wildignore=vendor/rails/** " ignore paths during tab completion
set ignorecase                 " case insensitive search
set smartcase                  " (unless your search query has caps)

" }}}-------------------------------------------------------------------------
" Status Line                                                              {{{
" ----------------------------------------------------------------------------

set noshowmode                    " don't show mode in last row, it's in airline.
set laststatus=2                  " Always display the status line
let g:airline_powerline_fonts = 1 " Enable special powerline font (requires install)
let g:airline_theme='base16'      " Airline theme
let g:airline_left_sep=''         " Controls airline separator characters
let g:airline_right_sep=''        " these can get a little goofy depending on font

" }}}-------------------------------------------------------------------------
" Input and Navigation                                                     {{{
" ----------------------------------------------------------------------------

if has("mouse")
  set mouse=a                  " Enable Mouse support
endif

set scrolloff=3                " how many lines to pad between cursor and edge of page when scrolling
set backspace=indent,eol,start " allow backspacing over autoindent, line breaks, start of inserts
set showmatch                  " briefly jump to the matching brace when you insert one, use matchtime to control how long.

set hlsearch                   " highlight matched search results
nnoremap <CR> :nohlsearch<cr>| " remove highlighting when you hit <Enter>
set incsearch                  " move cursor to matched string while typing pattern

" Nerd Tree binding and plugin options
map <leader>n :NERDTreeToggle <Return>
let NERDTreeDirArrows=0
let NERDTreeIgnore = ['\.DS_Store$']

nnoremap <leader>t :call PickFile()<CR>|   " Pick binding (an awesome fuzzy finder plugin)
nnoremap <leader>u :GundoToggle<CR>|       " Gundo binding (ultra-undo plugin)
nnoremap <leader>f :ChefFindAny<CR>|       " Open chef resource that cursor is on
nnoremap <leader>g :ChefFindAnyVsplit<CR>| " Same, but in vertical split pane

" }}}-------------------------------------------------------------------------
" Key Bindings                                                             {{{
" ----------------------------------------------------------------------------

" Note: pipe characters at the end of these commands are to allow
" inline comments. Gross hack job...But look how pretty!

command! W :w                    " For fat fingers
command! Q :q
imap <c-c> <esc>|                " Map Ctrl-c to <Esc> to ease finger gymnastics
imap <S-CR> <CR><CR>end<Esc>-cc| " Shift-Enger to insert 'end' from insert mode, broken?
map Q gq|                        " shortcut to rewrap selected text
map <leader>m Jxi\n<ESC>|        " Merge Lines, replacing newlines with \n char
nnoremap gV `[v`]|               " Highlight last inserted text

" Shortcut to pretty-format ugly blocks of json
nmap <leader>j <Esc>:%!python -m json.tool<CR><ESC>gg=G<Esc>:noh<CR>

" }}}-------------------------------------------------------------------------
" Folding                                                                  {{{
" ----------------------------------------------------------------------------

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
nnoremap <space> za|    " space open/closes folds

" }}}-------------------------------------------------------------------------
" Indentation and Whitespace                                               {{{
" ----------------------------------------------------------------------------

set tabstop=2      " How many spaces per <Tab> char, for existing text
set shiftwidth=2   " Number of space chars used for indentation
set softtabstop=2  " Treat our hard tabs like soft tabs (backspace deletes 2 spaces)
set expandtab      " When inserting <Tab> char, write as spaces instead.
set autoindent     " copies indentation level from the previous line, shouldn't interfere with filetype indent.

" }}}-------------------------------------------------------------------------
" Filetype Handling                                                        {{{
" ----------------------------------------------------------------------------

filetype plugin indent on " enable modified behaviour by file extension

" Whitespace
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Workaround for crappy filetype detection in vim-chef plugin
" Replace with your cookbook path
autocmd BufRead,BufNewFile ~/git/cpconfig/cookbooks/* set filetype=ruby.chef

" }}}-------------------------------------------------------------------------
" Color                                                                    {{{
" ----------------------------------------------------------------------------

syntax on                   " enable file syntax highlighting

if &term == "screen"
  set t_Co=256              " Force 256 color only if needed
endif

" Base16 plugin options
let base16colorspace=256    " Enable 256 color mode
colorscheme base16-eighties " set color scheme
set background=dark         " Use dark instead of light

" Custom modifications
highlight LineNr ctermfg=blue " blue line numbers
hi link jsonBraces Function|  " pretty blue braces instead of red

" }}}-------------------------------------------------------------------------
" Appearance                                                               {{{
" ----------------------------------------------------------------------------

let g:indentLine_noConcealCursor=""  "  prevent conflict in vim-json and indentLine
set synmaxcol=500                    "  Prevent performance issues on long lines
set nowrap                           "  Don't wrap lines by default
set cursorline                       "  highlight cursor location
set number                           "  show line numbers

" }}}-------------------------------------------------------------------------
" Custom Functions                                                         {{{
" ----------------------------------------------------------------------------

" Paste Toggle
" The following sets a variable to keep track of paste mode, and turns
" both paste mode and insert lines on and off for copying and pasting
let g:pasteMode = 0
function PasteToggle()
  if g:pasteMode
    IndentLinesEnable
    set nopaste
    set nowrap
    set number
    if has("mouse")
      set mouse=a
    endif
    setlocal conceallevel=2
    let g:pasteMode = 0
    echom "Paste mode OFF!"
  else
    IndentLinesDisable
    set mouse=""
    set paste
    set wrap
    set nonumber
    setlocal conceallevel=0
    let g:pasteMode = 1
    echom "Paste mode ON!"
  endif
endfunction
map <leader>p :call PasteToggle()<cr>


" Automatically create backup/tmp dirs for vim
" in ~/.vim
" Filenames are full paths with % separators
function! InitBackupDir()
  if has('win32') || has('win32unix') "windows/cygwin
    let l:separator = '_'
  else
    let l:separator = '.'
  endif
  let l:parent = $HOME . '/' . l:separator . 'vim/'
  let l:backup = l:parent . 'backup/'
  let l:tmp = l:parent . 'tmp/'
  if exists('*mkdir')
    if !isdirectory(l:parent)
      call mkdir(l:parent)
    endif
    if !isdirectory(l:backup)
      call mkdir(l:backup)
    endif
    if !isdirectory(l:tmp)
      call mkdir(l:tmp)
    endif
  endif
  let l:missing_dir = 0
  if isdirectory(l:tmp)
    execute 'set backupdir=' . escape(l:backup, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if isdirectory(l:backup)
    execute 'set directory=' . escape(l:tmp, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if l:missing_dir
    echo 'Warning: Unable to create backup directories:' l:backup 'and' l:tmp
    echo 'Try: mkdir -p' l:backup
    echo 'and: mkdir -p' l:tmp
    set backupdir=.
    set directory=.
  endif
endfunction
call InitBackupDir()
" }}}
" vim:foldmethod=marker:foldlevel=0
