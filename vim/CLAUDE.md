# Neovim Configuration Guidelines

## Commands
- **Install plugins**: Run Neovim and plugins will auto-install
- **Update plugins**: `:Lazy update` - Update installed plugins 
- **Format code**: `:Format` - Format current buffer using CoC
- **Format JSON**: `:FormatJSON` - Format JSON files using Python
- **Lint**: CoC provides inline linting via configured language servers

## Code Style Guidelines
- **Indentation**: 4 spaces (no tabs)
- **Line endings**: Unix style (LF)
- **Text encoding**: UTF-8
- **Plugin config**: Group related settings together with clear section comments
- **Lua style**: 
  - Use 2-space indentation for lua files
  - Prefer `vim.opt` over `vim.o` for options
  - Use `vim.api.nvim_set_keymap` for key mappings
  - Organize plugins by functionality
- **Naming**: Use descriptive names for functions and variables
- **Functions**: Prefer Lua functions over Vim functions when possible
- **Comments**: Describe "why" not just "what" with clear section headers
- **Error handling**: Use protected calls for operations that might fail

## Neovim/Lua Organization
- Plugin specifications should be in `init.lua`
- Custom Lua modules should be placed in `lua/` directory
- Plugin-specific configuration in separate files when complex
- Use `require()` for modular organization