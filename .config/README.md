# .config Directory

This directory contains configuration files for various programs that store their settings in `~/.config/`.

## Contents

- **nvim/**: Neovim configuration
  - `init.lua`: Main configuration file
  - `coc-settings.json`: Configuration for CoC (Conquer of Completion)
  - `lua/`: Lua modules

## Usage with Stow

These files are automatically symlinked to the correct locations when using GNU Stow:

```bash
cd ~/dotfiles
stow .
```

## Troubleshooting

If you encounter the error:
```
Error invoking 'doAutocmd' on channel 3 (coc): Request textDocument/codeAction failed with message: Could not find config file.
```

Make sure:
1. The symlinks are correctly created
2. Neovim can find the coc-settings.json file
3. The CoC extensions are installed