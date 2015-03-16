" Misc {{{
" Set up Pathogen Bundle Mangement
call pathogen#infect()
call pathogen#helptags()

set nocompatible " enable modern features
set hidden       " hide buffers so we don't have to write them when working on another file
set lazyredraw   " redraw only when we need to.
set history=1000
" }}}
" Input and Navigation {{{
if has("mouse")
  set mouse=a " Enable Mouse support
endif

set wildmenu                   " Enable menu during command tab completion
set wildmode=longest:full,full " 1st tab = longest commong string, subsequent show possible full matches
set wildignore=vendor/rails/** " ignore paths during tab completion

set ignorecase " case insensitive search
set smartcase  " (unless your search query has caps)

set scrolloff=3                " how many lines to pad between cursor and edge of page when scrolling
set backspace=indent,eol,start " allow backspacing over autoindent, line breaks, start of inserts
set showmatch                  " briefly jump to the matching brace when you insert one, use matchtime to control how long.

" highlight matched search results
" remove highlighting when you hit <Enter>
set hlsearch
nnoremap <CR> :nohlsearch<cr>
set incsearch " move cursor to matched string while typing pattern

let mapleader="," " for various shortcuts later

" Nerd-tree directory browser binding and plugin options
map <leader>n :NERDTreeToggle <Return>
let NERDTreeDirArrows=0
let NERDTreeIgnore = ['\.DS_Store$']

" shortcut to rewrap selected text
map Q gq

" For fat fingers: make :W == :w
command! W :w

" map Ctrl-c to <Esc> to ease finger gymnastics
imap <c-c> <esc>

" This is supposed to add an 'end' from insert mode
" with <Shift-Enter>. Don't think it is working.
" Would be awesome for writing ruby if it worked.
imap <S-CR> <CR><CR>end<Esc>-cc

" Merge Lines, replacing newlines with \n char
map <leader>m Jxi\n<ESC>

" Pick binding (an awesome fuzzy finder plugin)
nnoremap <Leader>t :call PickFile()<CR>

" toggle gundo (ultra-undo plugin)
nnoremap <leader>u :GundoToggle<CR>

" highlight last inserted text
nnoremap gV `[v`]
" }}}
" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
" space open/closes folds
nnoremap <space> za
" }}}
" Indentation and Whitespace {{{
set tabstop=2      " How many spaces per <Tab> char, for existing text
set shiftwidth=2   " Number of space chars used for indentation
set softtabstop=2  " Treat our hard tabs like soft tabs (backspace deletes 2 spaces)
set expandtab      " When inserting <Tab> char, write as spaces instead.
set autoindent     " copies indentation level from the previous line, shouldn't interfere with filetype indent.
filetype plugin on " determine various behaviour by file extension
filetype indent on " indent based on file-type
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
" }}}
" Appearance and Highlighting {{{

syntax on " enable file syntax highlighting

" Force 256 color only if needed
" If color isn't working, fix your $TERM!
" (Check iTerm2 settings, it doesn't default to 256.)
if &term == "screen"
  set t_Co=256
endif

color solarized     " Use solarized color scheme
set background=dark " Use dark instead of light

" make error text more obvious in solarized (black on red)
autocmd ColorScheme * highlight Error ctermbg=red ctermfg=256

" prevent conflict in vim-json and indentLine
let g:indentLine_noConcealCursor=""
set nowrap

" pretty blue braces
hi link jsonBraces Function

" Keeps vim from slowing down on huge lines
" (stop formatting at column 220)
set synmaxcol=220

set cursorline  " highlight cursor location
set cmdheight=1 " how tall is command line
set number      " show line numbers

" Shortcut to pretty-format ugly blocks of json
nmap <leader>j <Esc>:%!python -m json.tool<CR><ESC>gg=G<Esc>:noh<CR> 

" jamessan's status line
set laststatus=2                                                  " Always display status line
set statusline=                                                   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                                           " buffer number
set statusline+=%f\                                               " file name
set statusline+=%h%m%r%w                                          " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},                       " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc},                      " encoding
set statusline+=%{&fileformat}]                                   " file format
set statusline+=%=                                                " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\ " highlight
set statusline+=%b,0x%-8B\                                        " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P                             " offset
" }}}
" Custom Functions {{{
" Paste Mode
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


" Automatically create backup/cache dirs for vim
" in ~/.vim-tmp/
" Filenames are full paths with % separators
function! InitBackupDir()
  if has('win32') || has('win32unix') "windows/cygwin
    let l:separator = '_'
  else
    let l:separator = '.'
  endif
  let l:parent = $HOME . '/' . l:separator . 'vim-tmp/'
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
