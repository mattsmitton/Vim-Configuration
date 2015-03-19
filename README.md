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

* Setup and run Vundle

  ```
  cd .vim
  mkdir bundle
  git clone https://github.com/gmarik/Vundle.vim.git bundle/Vundle.vim
  vim +PluginInstall +qall
  ```
