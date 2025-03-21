# Dotfiles

This repository contains my personal dotfiles managed with GNU Stow.

## Setup

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   ```

2. Install GNU Stow:
   ```bash
   # macOS
   brew install stow
   ```

3. Create symlinks:

   **Option 1: Manual symlinks for Neovim (most reliable)**
   ```bash
   # Create necessary directories
   mkdir -p ~/.config/nvim/lua
   
   # Create symbolic links for Neovim
   ln -sf ~/dotfiles/.config/nvim/init.lua ~/.config/nvim/
   ln -sf ~/dotfiles/.config/nvim/coc-settings.json ~/.config/nvim/
   ln -sf ~/dotfiles/.config/nvim/lua/local.lua ~/.config/nvim/lua/
   ```

   **Option 2: Using GNU Stow**
   ```bash
   cd ~/dotfiles
   stow -t ~ zsh-stow    # Only stow ZSH configuration
   stow -t ~ git-stow    # Only stow Git configuration
   ```

## Components

- **git-stow**: Git configuration
- **zsh-stow**: ZSH shell configuration 
- **.config**: Neovim and other application configs

## Keyboard Layouts

Mac:
- Copy Keyboard Layouts to /Library/Keyboard Layouts/

