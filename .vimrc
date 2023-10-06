" ----------------------------------------------------------------------------
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
" First, install vim-plug
" neovim: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" vim 8+: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Setup plugin directories
if has('nvim')
  call plug#begin('~/.local/share/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" Nvim only plugins
if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}    " Autocomplete for most things
  " Plug 'Shougo/deoplete.nvim' " Terraform-friendly autocomplete engine
  " Plug 'Shougo/neosnippet.vim' " Snippet support
  " Plug 'honza/vim-snippets'   " Big collection of snippets for different filetypes. Maybe too many.
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
  " Plug 'juliosueiras/vim-terraform-completion'  " Terraform autocompletion for neovim
endif

" Vim 8 only plugins
if !has('nvim')
  "Plug 'roxma/nvim-yarp'          " Add vim 8+ support for deoplete
  "Plug 'roxma/vim-hug-neovim-rpc' " Add vim 8+ support for deoplete
endif

" All the rest go here
Plug 'Yggdroot/indentLine'                    " Sublime-like vertical guide lines
Plug 'airblade/vim-gitgutter'                 " adds git diff column and highlighting options
Plug 'avakhov/vim-yaml'                       " yaml highlighting
Plug 'beeerd/vim-chef-goto'                   " chef go-to-file support
Plug 'bling/vim-airline'                      " Fancy status line
" Plug 'bracki/vim-prometheus'                  " Prometheus support
Plug 'chriskempson/base16-vim'                " Lots of color schemes
Plug 'ekalinin/Dockerfile.vim'                " Dockerfile linting
Plug 'elzr/vim-json'                          " json highlighting
Plug 'erikzaadi/vim-ansible-yaml'             " Ansible YAML support
" Plug 'github/copilot.vim'                     " Borg code
Plug 'godlygeek/tabular'                      " quick regex based formatting (v-mode highlight ':Tab /<pattern>'
Plug 'hashivim/vim-terraform'                 " Terraform syntax highlighting and :Terraform cmd
Plug 'jremmen/vim-ripgrep'                    " Grep, but better
Plug 'junegunn/fzf'                           " Fuzzy finder
Plug '/usr/local/opt/fzf'                     " We already installed this with brew right?
Plug 'luochen1990/rainbow'                    " rainbow parentheses
" Plug 'kchmck/vim-coffee-script'               " coffee-script highlighting
" Plug 'lepture/vim-jinja'                      " Jinja support
" Plug 'mileszs/ack.vim'                        " Ack-find from within vim (:Ack <pattern>
Plug 'othree/javascript-libraries-syntax.vim' " javascript library syntax highlighting
Plug 'pangloss/vim-javascript'                " javascript highlighting
" Plug 'saltstack/salt-vim'                     " Saltstack file detection and highlighting
Plug 'scrooloose/nerdtree'                    " file tree navigator (n
Plug 'mbbill/undotree'                        " Mega Undo: graphical tree-based undo menu
Plug 'taylor/vim-zoomwin'                     " zoom in on a split pane (ctrl+w-o
Plug 'tomtom/tcomment_vim'                    " add shortcut for commenting ('g-c-c'
Plug 'tpope/vim-fugitive'                     " Git integration
Plug 'tpope/vim-markdown'                     " markdown highlighting
Plug 'tpope/vim-surround'                     " quick shortcuts for delimiters
Plug 'vim-airline/vim-airline-themes'         " Add additional airline themes
Plug 'vim-ruby/vim-ruby'                      " ruby highlighting
Plug 'dense-analysis/ale'                     " Asynchronous linting
Plug 'towolf/vim-helm'                        " Helm syntax highlighting

call plug#end()


" }}}-------------------------------------------------------------------------
" General/Misc                                                             {{{
" ----------------------------------------------------------------------------
" syntax enable
set hidden        " hide buffers so we don't have to write them when working on another file
set lazyredraw    " redraw only when we need to.
let mapleader="," " for various shortcuts later

if !has('nvim')
  set history=1000  " remember past 1000 commands
  set ttyfast       " Indicates a fast terminal connection

  "Use a block cursor in normal/visual mode
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
endif

" }}}-------------------------------------------------------------------------
" Command Line                                                            {{{
" ----------------------------------------------------------------------------

if !has('nvim')
  set cmdheight=1 " how tall is command line
  set wildmenu    " Enable menu during command tab completion
endif

set wildmode=longest:full " 1st tab = longest common string, subsequent show possible full matches
set wildignore=vendor/**  " ignore paths during tab completion
set ignorecase            " case insensitive search
set smartcase             " (unless your search query has caps)

" }}}-------------------------------------------------------------------------
" Status Line                                                              {{{
" ----------------------------------------------------------------------------

if !has('nvim')
  set laststatus=2                         " Always display the status line
endif

set noshowmode                           " don't show mode in last row, reserve it for airline.
let g:airline_powerline_fonts = 1        " Enable special powerline font (requires install)
let g:airline_theme='base16'             " Airline theme
let g:airline_left_sep=''                " Controls airline separator characters
let g:airline_right_sep=''               " these can get a little goofy depending on font
let g:airline#extensions#ale#enabled = 1 " Enable ale support


" }}}-------------------------------------------------------------------------
" Autocomplete                                                             {{{
" ----------------------------------------------------------------------------

if has('nvim')
  "" CoC Setup
  fun! LoadCocPlugin()
    " Skip if it's a Terraform file, in which case we want deoplete
    " if &ft == "terraform"
    "   return
    " endif
    call plug#load('neoclide/coc.nvim')
  endfun

  augroup LoadCoc
    " remove any previously loaded autocmd! for the InsertEnter event
    autocmd!
    autocmd InsertEnter * call LoadCocPlugin() | autocmd! LoadCoc
  augroup END

  " use <tab> for trigger completion and navigate to next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

  " Use <Tab> and <S-Tab> for navigate CoC completion list
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " Use <enter> to confirm complete
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  let g:coc_snippet_next = '<TAB>'
  let g:coc_snippet_prev = '<S-TAB>'

  " Close preview window when completion is done.
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  " Terraform options
  " Requires deoplete ... just waiting on a coc-friendly extension
  " if &ft == "terraform"
  "   let g:deoplete#omni_patterns = {}
  "   let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
  "   let g:deoplete#enable_at_startup = 1
  "   call deoplete#initialize()
  "   let g:terraform_completion_keys = 1
  "   let g:terraform_registry_module_completion = 1
  "
  "   " Setup snippet support
  "   let g:neosnippet#disable_runtime_snippets = 1
  "   let g:neosnippet#enable_snipmate_compatibility = 1
  "   let g:neosnippet#snippets_directory='~/.local/nvim/plugged/vim-terraform-completion/snippets/terraform'
  "   imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  "   smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  "   xmap <C-k>     <Plug>(neosnippet_expand_target)
  "
  "   " imap <expr><TAB>
  "   " \ pumvisible() ? "\<C-n>" :
  "   " \ neosnippet#expandable_or_jumpable() ?
  "   " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  "   "
  "   " smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  "   " \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  "
  "   " function! s:check_back_space() abort
  "   "   let col = col('.') - 1
  "   "   return !col || getline('.')[col - 1]  =~ '\s'
  "   " endfunction
  "   " inoremap <silent><expr> <TAB>
  "   "       \ pumvisible() ? "\<C-n>" :
  "   "       \ <SID>check_back_space() ? "\<TAB>" :
  "   "       \ deoplete#manual_complete()
  " endif

endif

" }}}-------------------------------------------------------------------------
" Input and Navigation                                                     {{{
" ----------------------------------------------------------------------------

if !has('nvim')
  set incsearch " move cursor to matched string while typing pattern
endif

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

" Call rubocop with autocorrect
map <leader>R :call RunRubocop()<CR>

" }}}-------------------------------------------------------------------------
" Folding                                                                  {{{
" ----------------------------------------------------------------------------

if !has('nvim')
  set foldenable          " enable folding
endif

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

filetype plugin indent on " enable modified behaviour by file extension

" Whitespace, etc
if has('autocmd')
  au FileType cpp,c,java,sh,pl,php set cindent
  au FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class ts=4 sts=4 sw=4 fdm=indent
  au FileType groovy set cinwords=if,else,for,while,try,catch,finally,def,given,when,then,switch ts=4 sts=4 sw=4 fdm=indent
  au FileType ruby,ruby.chef set cinwords=if,elsif,else,for,while,until,except,begin,rescue,ensure,def,do,class ts=2 sts=2 sw=2 fdm=indent
  au BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
  au FileType make setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
  au BufRead *.md set conceallevel=2 wrap linebreak
  au BufRead *.nomad set filetype=hcl
endif

" Workaround for crappy filetype detection in vim-chef plugin
" Replace with your cookbook path
autocmd BufRead,BufNewFile ~/git/github/*/ops_chef*/*\.rb set filetype=ruby.chef

" }}}-------------------------------------------------------------------------
" Color & Syntax                                                           {{{
" ----------------------------------------------------------------------------
if !has('nvim')
  " vim documentation on this is a little confusing.
  " nvim doesn't seem to require it.
  if !exists("g:syntax_on")
    syntax enable
  endif
endif


if &term == "screen"
  set t_Co=256              " Force 256 color only if needed
endif

" Base16 plugin options
" .vimrc_background is written out by base16-shell
" This just keeps vim/shell in sync.
" https://github.com/chriskempson/base16-shell
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
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
    if !has('nvim')
      set nopaste
    endif
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
    if !has('nvim')
      set paste
    endif
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
