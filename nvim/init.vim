" ----------------------------------------------------------------------------
"
"              _)        _)  |            _)
"               |  __ \   |  __|  \ \   /  |  __ `__ \
"               |  |   |  |  |     \ \ /   |  |   |   |
"              _| _|  _| _| \__| _) \_/   _| _|  _|  _|
"
" This init.vim file uses folding to manage the display of its contents.
" Use the 'zR' command to open all of the sections if you're lost...
" ----------------------------------------------------------------------------
" Plugins                                                                  {{{
" ----------------------------------------------------------------------------
" This is where you put all your github-sourced vim plugins
" First, install vim-plug
" neovim: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Setup plugin directories
call plug#begin('~/.local/share/nvim/plugged')

" Avante Deps
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'

" Avante Optional deps
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-tree/nvim-web-devicons' "or Plug 'echasnovski/mini.icons'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'zbirenbaum/copilot.lua'
Plug 'stevearc/dressing.nvim' " for enhanced input UI
Plug 'folke/snacks.nvim' " for modern input UI

" Avante... pass source=true if you want to build from source
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }

" All the rest go here
Plug '/usr/local/opt/fzf'                     " We already installed this with brew right?
Plug 'GutenYe/json5.vim'                      " json5 highlighting (should be built-in for nvim soon...)
Plug 'Yggdroot/indentLine'                    " Sublime-like vertical guide lines
Plug 'airblade/vim-gitgutter'                 " adds git diff column and highlighting options
Plug 'avakhov/vim-yaml'                       " yaml highlighting
Plug 'beeerd/vim-chef-goto'                   " chef go-to-file support
Plug 'bling/vim-airline'                      " Fancy status line
Plug 'chriskempson/base16-vim'                " Lots of color schemes
Plug 'dense-analysis/ale'                     " Asynchronous linting
Plug 'ekalinin/Dockerfile.vim'                " Dockerfile linting
Plug 'elzr/vim-json'                          " json highlighting
Plug 'erikzaadi/vim-ansible-yaml'             " Ansible YAML support
Plug 'godlygeek/tabular'                      " quick regex based formatting (v-mode highlight ':Tab /<pattern>'
Plug 'hashivim/vim-terraform'                 " Terraform syntax highlighting and :Terraform cmd
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'inkarkat/vim-AdvancedSorters'           " Advanced sorting options
Plug 'jremmen/vim-ripgrep'                    " Grep, but better
Plug 'junegunn/fzf'                           " Fuzzy finder
Plug 'luochen1990/rainbow'                    " rainbow parentheses
Plug 'mbbill/undotree'                        " Mega Undo: graphical tree-based undo menu
Plug 'othree/javascript-libraries-syntax.vim' " javascript library syntax highlighting
Plug 'pangloss/vim-javascript'                " javascript highlighting
Plug 'scrooloose/nerdtree'                    " file tree navigator (n
Plug 'taylor/vim-zoomwin'                     " zoom in on a split pane (ctrl+w-o
Plug 'tomtom/tcomment_vim'                    " add shortcut for commenting ('g-c-c'
Plug 'towolf/vim-helm'                        " Helm syntax highlighting
Plug 'tpope/vim-fugitive'                     " Git integration
Plug 'tpope/vim-markdown'                     " markdown highlighting
Plug 'tpope/vim-surround'                     " quick shortcuts for delimiters
Plug 'vim-airline/vim-airline-themes'         " Add additional airline themes
Plug 'inkarkat/vim-ingo-library'              " Required for vim-AdvancedSorters
Plug 'vim-ruby/vim-ruby'                      " ruby highlighting

call plug#end()

lua require('config')

" }}}-------------------------------------------------------------------------
" General/Misc                                                             {{{
" ----------------------------------------------------------------------------
syntax enable
set hidden        " hide buffers so we don't have to write them when working on another file
set lazyredraw    " redraw only when we need to.
let mapleader="," " for various shortcuts later


" }}}-------------------------------------------------------------------------
" Command Line                                                            {{{
" ----------------------------------------------------------------------------

set wildmode=longest:full " 1st tab = longest common string, subsequent show possible full matches
set wildignore=vendor/**  " ignore paths during tab completion
set ignorecase            " case insensitive search
set smartcase             " (unless your search query has caps)


" }}}-------------------------------------------------------------------------
" Status Line                                                              {{{
" ----------------------------------------------------------------------------

set noshowmode                           " don't show mode in last row, reserve it for airline.
let g:airline_powerline_fonts = 1        " Enable special powerline font (requires install)
let g:airline_theme='base16'             " Airline theme
let g:airline_left_sep=''                " Controls airline separator characters
let g:airline_right_sep=''               " these can get a little goofy depending on font
let g:airline#extensions#ale#enabled = 1 " Enable ale support


" }}}-------------------------------------------------------------------------
" Input and Navigation                                                     {{{
" ----------------------------------------------------------------------------

if has("mouse")
  set mouse=a " Enable Mouse support
endif

set scrolloff=3                " how many lines to pad between cursor and edge of page when scrolling
set backspace=indent,eol,start " allow backspacing over autoindent, line breaks, start of inserts
set showmatch                  " briefly jump to the matching brace when you insert one, use matchtime to control how long.

set hlsearch                   " highlight matched search results
nnoremap <CR> :nohlsearch<cr>| " remove highlighting when you hit <Enter>

" Nerd Tree binding and plugin options
map <leader>n :NERDTreeToggle <Return>
let NERDTreeDirArrows=0
let NERDTreeIgnore = ['\.DS_Store$']

" FZF/Ripgrep (fuzzy find and fast search options)
nnoremap <C-p> :Files<cr>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~20%' }
" Once nvim has window support...
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '10split enew' }

let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,md,html,config,py,cpp,c,go,hs,rb,conf,sql,rb,tf,txt}"
  \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,build,dist}/*" '

nnoremap <leader>s :FZF <CR>|              " Fuzzy find/open files with FZF
nnoremap <leader>u :UndotreeToggle<CR>|    " Undotree binding (ultra-undo plugin)
nnoremap <leader>f :ChefFindAny<CR>|       " Open chef resource that cursor is on
nnoremap <leader>g :ChefFindAnyVsplit<CR>| " Same, but in vertical split pane
nnoremap <leader>w ::%s/\s\+$//<CR>|       " Remove all trailing whitespace
nnoremap <leader>t ::%s/\t/  /<CR>|        " Replace all tabs with 2 spaces

" }}}-------------------------------------------------------------------------
" Key Bindings                                                             {{{
" ----------------------------------------------------------------------------

" Note: pipe characters at the end of these commands are to allow
" inline comments. Gross hack job...But look how pretty!

" For fat fingers
command! W :w
command! Q :q

imap <c-c> <esc>|                " Map Ctrl-c to <Esc> to ease finger gymnastics
map <leader>m Jxi\n<ESC>|        " Merge Lines, replacing newlines with \n char
nnoremap gV `[v`]|               " Highlight last inserted text

" Shortcut to pretty-format ugly blocks of json
nmap <leader>j <Esc>:%!python -m json.tool<CR><ESC>gg=G<Esc>:noh<CR>

" To switch symbol chef attribs to strings
nmap <leader>a <Esc>:%s/\[\:\(\w\+\)\]/\[\'\1\'\]/g<CR>

" Left align two columns in an indented block, useful for chef
vmap <leader>l :Tab / \+\w\+ /l0l0l0<CR>

" Automatically backup knife changes when exiting INSERT mode
autocmd BufNewFile,BufRead */knife-edit* inoremap <Esc> <Esc>:w! ~/.vim/backup/knife-last<CR>

" Copy selected text to clipboard
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>

" Enable native clipboard integration
set clipboard=unnamedplus

" Call rubocop with autocorrect
map <leader>R :call RunRubocop()<CR>

" Open copilot chat window
nmap <leader>cc :CopilotChat<CR>
" }}}-------------------------------------------------------------------------
" Folding                                                                  {{{
" ----------------------------------------------------------------------------

set foldlevelstart=10   " open most folds by default
" set foldnestmax=10      " 10 nested fold max, default is 20
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
set smartindent

" }}}-------------------------------------------------------------------------
" Filetype Handling                                                        {{{
" ----------------------------------------------------------------------------

filetype on
filetype plugin indent on " enable modified behaviour by file extension

" Whitespace, etc
augroup filetypedetect
  autocmd FileType cpp,c,java,sh,pl,php setlocal cindent
  autocmd FileType python setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class ts=4 sts=4 sw=4 fdm=indent
  autocmd FileType groovy setlocal cinwords=if,else,for,while,try,catch,finally,def,given,when,then,switch ts=4 sts=4 sw=4 fdm=indent
  autocmd FileType ruby,ruby.chef setlocal cinwords=if,elsif,else,for,while,until,except,begin,rescue,ensure,def,do,class ts=2 sts=2 sw=2 fdm=indent
  autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType make setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
  autocmd BufRead *.md setlocal conceallevel=2 wrap linebreak
  autocmd BufRead *.nomad setlocal filetype=hcl
  autocmd BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
  autocmd BufRead,BufNewFile *.tf let b:ale_linters = {'terraform': ['terraform', 'terraform_ls', 'terraform_lsp', 'tflint', 'tfsec']}
augroup END

" Workaround for crappy filetype detection in vim-chef plugin
" Replace with your cookbook path
autocmd BufRead,BufNewFile ~/git/github/*/ops_chef*/*\.rb setlocal filetype=ruby.chef


" }}}-------------------------------------------------------------------------
" Color & Syntax                                                           {{{
" ----------------------------------------------------------------------------
if &term == "screen"
  set t_Co=256              " Force 256 color only if needed
endif

" Base16 plugin options
" $BASE16_THEME is populated by base16-shell
" This just keeps vim/shell in sync.
" https://github.com/chriskempson/base16-shell
if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

" Rainbow parens/braces
let g:rainbow_active = 1

" Custom color modifications
hi LineNr ctermfg=blue         " blue line numbers
hi CursorLineNr ctermfg=yellow " Cursor line number is yellow

" Swap file write interval (in ms)
set updatetime=2000

" Use local rubocop
let g:ale_ruby_rubocop_executable = "bundle"
if filereadable(expand("./rubocop.yml"))
  let g:ale_ruby_rubocop_options = "-c rubocop.yml"
else
  let g:ale_ruby_rubocop_options = "-c ~/.rubocop.yml"
endif

" Autofix some things
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'terraform': ['terraform'],
\}
" Seems this is kinda broken in neovim, if you :wq
" :w works fine.
let g:ale_fix_on_save = 1

" }}}-------------------------------------------------------------------------
" Appearance                                                               {{{
" ----------------------------------------------------------------------------

let g:indentLine_noConcealCursor="" " prevent conflict in vim-json and indentLine
set synmaxcol=500                   " Prevent performance issues on long lines
set nowrap                          " Don't wrap lines by default
set cursorline                      " highlight cursor location
set relativenumber                  " Show relative line numbers for all but current line
set number                          " Show real line number for current line


" }}}-------------------------------------------------------------------------
" Custom Functions                                                         {{{
" ----------------------------------------------------------------------------
" Paste Toggle
" The following sets a variable to keep track of paste mode, and toggles
" both paste mode and insert lines for copying and pasting
" paste mode is obsolete in nvim, but it's nice to disable some of the
" formatting when copying
let g:pasteMode = 0
function PasteToggle()
  if g:pasteMode
    IndentLinesEnable
    GitGutterEnable
    set nowrap
    set number
    set relativenumber
    if has("mouse")
      set mouse=a
    endif
    setlocal conceallevel=2
    let g:pasteMode = 0
    echom "Paste mode OFF!"
  else
    IndentLinesDisable
    GitGutterDisable
    set mouse=""
    set wrap
    set nonumber
    set norelativenumber
    setlocal conceallevel=0
    let g:pasteMode = 1
    set expandtab
    echom "Paste mode ON!"
  endif
endfunction
map <leader>p :call PasteToggle()<cr>

" Automatically create backup/tmp dirs for vim
"
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
