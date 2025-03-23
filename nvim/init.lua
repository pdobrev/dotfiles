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
  { "junegunn/fzf.vim" },
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
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "stevearc/conform.nvim" },
  { "ray-x/lsp_signature.nvim" },
})

-- General settings
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamed"
vim.opt.signcolumn = "yes" -- Always show the sign column to prevent text shifting

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

-- LSP Configuration
local lspconfig = require('lspconfig')

-- Common LSP setup
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- signature help in insert mode too
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
  
  -- Diagnostics
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  
  -- Format on save is now handled by conform.nvim
  
  -- Highlight references on cursor hold
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
  
  -- Setup lsp_signature for a gentler signature help experience
  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = {
      border = "rounded"
    },
    hint_enable = false,          -- Disable virtual text hints
    floating_window = true,       -- Use floating window for signature
    always_trigger = false,       -- Don't show signature help automatically for every char
    floating_window_above_cur_line = true,
    close_timeout = 4000,         -- Close after 4 seconds of inactivity
    toggle_key = '<C-k>',         -- Toggle signature with the same key as manual trigger
    select_signature_key = '<C-n>', -- Cycle between signatures
  }, bufnr)
end

-- Setup nvim-cmp
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
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Setup cmdline completion
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup LSP capabilities with nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Initialize language servers
-- Use typescript-language-server
require('lspconfig').ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  -- Import preferences from coc-settings
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "relative"
      }
    }
  }
})

-- Setup conform.nvim for formatting
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
    async = true, -- Async formatting
  },
})

-- Diagnostic config similar to coc
vim.diagnostic.config({
  virtual_text = { 
    prefix = '■', -- Use a visible marker for virtual text
    spacing = 2,  -- Add spacing before the message
  },
  signs = true,
  underline = true,
  update_in_insert = false, -- Don't update diagnostics in insert mode
  severity_sort = true,
  float = {
    focusable = false,
    source = 'always',
    header = '',
    prefix = '',
    border = 'rounded',
  },
})

-- Define more visible signs
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Create user command for format (async by default)
vim.api.nvim_create_user_command('Format', function() 
  require("conform").format({ async = true, lsp_fallback = true })
end, {})
