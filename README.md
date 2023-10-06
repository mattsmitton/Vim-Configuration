Recommended Installation
------------------------

Note: I'm in the process of adopting neovim. For the time being, this config
is compatible with both vim 8+ and neovim, but using neovim is recommended.

**Move to your homedir**

` cd ~`

**If you already have a vim config, back it up now**

`mv .vim .vim-bak ; mv .vimrc .vimrc-bak`

**Clone this down**

`git clone git://github.com/mattsmitton/Vim-Configuration.git .vim`

**Create a symlink in your homedir from .vimrc to the .vimrc inside this .vim dir**

`ln -s .vim/.vimrc`

**Extra steps for neovim support**

```
mkdir -p ~/.config/nvim
ln -s ~/.vim/init.vim ~/.config/nvim/init.vim
```

**Install and run vim-plug to install plugins**

```
# If you want vim 8 support
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall

# If you want neovim support
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall
```
