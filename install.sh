#!/bin/bash

# Backup existing Neovim config if present
if [ -d "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim-bak"
  echo "Backed up existing Neovim config to ~/.config/nvim-bak"
fi

# Symlink entire nvim config directory
ln -sf "$HOME/.vim/nvim" "$HOME/.config/nvim"

# Install vim-plug for Neovim
curl -sfLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
nvim +PlugInstall

echo "Neovim configuration setup complete."
