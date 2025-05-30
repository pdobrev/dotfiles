-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = " "

-- Plugin specification
require("lazy").setup({
  -- UI
  { "morhetz/gruvbox", priority = 1000 },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua", 
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("nvim-tree").setup() end
  },
  
  -- Tools
  { "junegunn/fzf", 
    build = function()
      vim.fn.system({ "bash", "-c", vim.fn.stdpath("data") .. "/lazy/fzf/install --all" })
    end 
  },
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },
  { "scrooloose/nerdcommenter" },
  { "github/copilot.vim" },
  { "chrisbra/csv.vim" },
  
  -- Markdown
  { "iamcco/markdown-preview.nvim", build = "cd app && npx --yes yarn install" },
  
  -- AI
  { "joshuavial/aider.nvim" },
  
  -- LSP and completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  
  { "nvim-telescope/telescope.nvim", 
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  
  { "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
})

-- General settings
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamed"

-- Create directory for swap files if it doesn't exist
local swap_dir = vim.fn.expand("~/.vim/tmp")
if vim.fn.isdirectory(swap_dir) == 0 then
  vim.fn.mkdir(swap_dir, "p")
end
vim.opt.directory = swap_dir
vim.opt.lazyredraw = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolljump = 7
vim.opt.scrolloff = 7
vim.opt.visualbell = false
-- termencoding is obsolete in Neovim
vim.opt.hidden = true
vim.opt.buflisted = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.encoding = "utf-8"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.formatoptions:append("cr")
vim.opt.errorbells = false
vim.opt.visualbell = true
-- t_vb is a terminal option not needed in Neovim

-- Set colorscheme
vim.cmd("colorscheme gruvbox")

-- Copilot configuration
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap('i', '<C-y>', 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })

-- NERD Commenter
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDSpaceDelims = 1
vim.api.nvim_set_keymap('v', '++', '<plug>NERDCommenterToggle', {})
vim.api.nvim_set_keymap('n', '++', '<plug>NERDCommenterToggle', {})

-- NvimTree
vim.api.nvim_set_keymap('n', ',d', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',n', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- Key mappings
vim.api.nvim_set_keymap('n', ',v', ':e ~/.config/nvim/init.lua<CR>', { noremap = true })
-- Add autocmd to reload config when saved
vim.cmd([[
  augroup config_reload
    autocmd!
    autocmd BufWritePost ~/.config/nvim/init.lua source <afile>
  augroup end
]])
vim.api.nvim_set_keymap('n', ',f', ':GFiles --cached --others --exclude-standard<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', ',r', ':Rg<CR>', { noremap = true })

-- FZF
vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden'
vim.api.nvim_set_keymap('n', '<C-P>', ':Files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F3>', ':Buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<F3>', '<Esc>:Buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F3>', '<Esc>:Buffers<CR>', { noremap = true })

-- Better visual mode indenting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Copy/Paste
vim.api.nvim_set_keymap('v', '<C-C>', '"+yi', {})
vim.api.nvim_set_keymap('i', '<C-V>', '<Esc>"+gPi', {})
vim.api.nvim_set_keymap('i', '<S-Insert>', '<Esc>"+gPi', {})

-- Terminal escape
vim.api.nvim_set_keymap('t', '<C-v><Esc>', '<C-\\><C-n>', { noremap = true })

-- Custom commands
vim.api.nvim_create_user_command('FormatJSON', '%!python3 -m json.tool', {})

-- Setup aider.nvim
require('aider').setup({ auto_manage_context = false, default_bindings = false })

-- Setup Telescope
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close
      },
    },
  },
}

-- Add Telescope key mappings
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })

-- LSP Configuration
local lspconfig = require('lspconfig')

-- Common capabilities including nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup LSP servers
local servers = {
  'pyright', -- Python
  'ts_ls', -- TypeScript
  'jsonls', -- JSON
  'eslint', -- ESLint
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- LSP keybindings (similar to what we had with CoC)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })

-- Setup diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Setup formatting via null-ls
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
  },
})

-- Create Format command (similar to CoC)
vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format({ async = true })
end, {})

-- Create space commands similar to CoC
vim.api.nvim_set_keymap('n', '<space>a', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>o', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>s', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })

vim.keymap.set('i', '<C-space>', vim.lsp.buf.signature_help, { buffer = bufnr })
