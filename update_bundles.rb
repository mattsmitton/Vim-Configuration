#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'


git_bundles = [ 
  "git://github.com/altercation/vim-colors-solarized.git", # the best color scheme ever.
  "https://github.com/dougireton/vim-chef",                 # chef linting
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
  "https://github.com/vim-scripts/FuzzyFinder",            # file search by file/pathname (,t)
  "https://github.com/vim-scripts/L9",                     # fuzzy-finder dep
  "https://github.com/mileszs/ack.vim.git",                # Ack-find from within vim (:Ack <pattern>)
  "https://github.com/Yggdroot/indentLine",                # Sublime-like vertical guide lines
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
