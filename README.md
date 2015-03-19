Recommended Installation
------------------------

*  Move to your homedir

  ` cd ~`

* If you already have a vim config, back it up now

  `mv .vim .vim-bak ; mv .vimrc .vimrc-bak`

* Copy this down

  `git clone git://github.com/beeerd/Vim-Configuration.git .vim`

* Create a symlink in your homedir from .vimrc to the .vimrc inside this.vim

  `ln -s .vim/.vimrc`

* Update bundles (Add whatever pathogen-compatible packages you want to this script)

  `ruby .vim/update_bundles.rb`
