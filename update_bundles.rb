#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'


git_bundles = [ 
  "https://github.com/dougireton/vim-chef",                # chef linting
  "https://github.com/kchmck/vim-coffee-script.git",       # coffee-script highlighting
  "git://github.com/pangloss/vim-javascript.git",          # javascript highlighting
  "https://github.com/elzr/vim-json",                      # json highlighting
  "git://github.com/tpope/vim-markdown.git",               # markdown highlighting
  "git://github.com/vim-ruby/vim-ruby.git",                # ruby highlighting
  "git://github.com/tpope/vim-rails.git",                  # rails highlighting
  "https://github.com/avakhov/vim-yaml.git",               # yaml highlighting
  "git://github.com/godlygeek/tabular.git",                # quick regex based formatting (v-mode highlight, ':Tab /<pattern>')
  "git://github.com/tpope/vim-surround.git",               # quick shortcuts for delimiters
  "git://github.com/scrooloose/nerdtree.git",              # file tree navigator (,n)
  "https://github.com/tomtom/tcomment_vim",                # add shortcut for commenting ('g-c-c')
  "https://github.com/taylor/vim-zoomwin",                 # zoom in on a split pane (ctrl+w-o)
  "https://github.com/scrooloose/syntastic.git",           # linter
  "https://github.com/mileszs/ack.vim.git",                # Ack-find from within vim (:Ack <pattern>)
  "https://github.com/Yggdroot/indentLine",                # Sublime-like vertical guide lines
  "https://github.com/thoughtbot/pick.vim",                # Fuzzy-finder, requires `brew tap thoughtbot/formulae ; brew install pick`
  "https://github.com/sjl/gundo.vim.git",                  # Mega Undo: graphical tree-based undo menu
  "https://github.com/bling/vim-airline",                  # Fancy status line
  "https://github.com/tpope/vim-fugitive",                 # Git integration
  "https://github.com/chriskempson/base16-vim.git"         # Lots of color schemes
]

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

unless File.exists?(bundles_dir)
   FileUtils.mkdir(bundles_dir) 
end

FileUtils.cd(bundles_dir)

puts "trashing everything (lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf d }

def download_repo(url)
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

git_bundles.each do |repo|
  if repo.class == Array
    download_repo(repo.delete_at(0))
    repo.each do |command|
      system(command)
    end
  else
    download_repo(repo)
  end
end
