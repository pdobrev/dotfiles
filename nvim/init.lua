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
  -- TreeSitter for better syntax highlighting and code understanding
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  
  -- GitHub
  { "tpope/vim-fugitive" },

  -- Automatic indentation detection
  { "tpope/vim-sleuth",
    lazy = false,
    priority = 900,
  },

  -- Tools
  { "ibhagwan/fzf-lua",
    build = function()
      -- Auto-install fzf if needed
      local function install_fzf()
        local is_mac = vim.fn.has('macunix') == 1

        if is_mac then
          print("Installing fzf with Homebrew...")
          vim.fn.system({"brew", "install", "fzf"})
          if vim.v.shell_error ~= 0 then
            print("Error installing fzf with Homebrew. Please install manually.")
            return false
          end
          print("fzf installed successfully!")
          return true
        else
          -- For Linux or Windows, provide instructions
          print("Please install fzf manually:")
          print("- Linux: Use your package manager (apt install fzf, pacman -S fzf, etc.)")
          print("- Windows: Use scoop, chocolatey, or download from GitHub")
          return false
        end
      end

      -- Check if fzf exists and install if needed
      if vim.fn.executable('fzf') ~= 1 then
        install_fzf()
      end
    end,

    config = function()
      require("fzf-lua").setup({
        -- Use system fzf
        fzf_bin = 'fzf',
        winopts = {
          preview = {
            default = "builtin",
            delay = 30,        -- Slightly reduced preview delay
            title = false,     -- Disable title
            delay_syntax = 150, -- Delay syntax highlighting even more
          },
          height = 0.65,       -- Shorter window height
          width = 0.80,
          row = 0.35,          -- Position near the middle of screen
          col = 0.5,           -- Center horizontally
          border = "single",     -- No border for faster rendering
          fullscreen = false,  -- Never use fullscreen
        },
        fzf_opts = {
          ["--layout"] = "reverse-list", -- Keep the input prompt line on the bottom
          ["--info"] = "inline",
          ["--tiebreak"] = "begin,index", -- Faster sorting
        },
        keymap = {
          fzf = {
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "clear-query",
          },
        },
        files = {
          fd_opts = "--color=never --type f --hidden --follow --exclude .git --max-depth 10", -- Limit depth for faster results
          multiprocess = true, -- Speed up file operations
          max_results = 1000,  -- Limit results for faster display
          file_icons = false,  -- Disable file icons
          git_file_shared_list = true, -- Share file list with git_files
          use_cache = true,   -- Cache results for reuse
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
          no_esc = true, -- disable auto-escaping characters in queries
          multiprocess = true, -- Faster grep operations
        },
        -- Performance optimizations
        previewer = {
          builtin = {
            strict_render = true,     -- Less redraws
            syntax_limit_b = 500000,  -- Limit syntax highlighting for large files
            delay_syntax = true,      -- Delay syntax highlighting for speed
            treesitter = { enable = false }, -- Disable treesitter in preview
          },
        },
        -- Faster buffer handling
        buffers = {
          sort_lastused = true,
          no_header_i = true,         -- Hide headers in insert mode
          file_icons = false,         -- Disable file icons in buffers
        },
        -- Global performance settings
        file_icons = false,            -- Disable file icons completely
        show_file_icons = false,       -- Ensure icons are disabled everywhere
        lazy_loading = {
          enabled = true,              -- Enable lazy loading
          throttle = 16,               -- ms
          lazy_seconds = 0.5           -- load after 0.5s
        },
      })
    end
  },
  { "scrooloose/nerdcommenter" },


  -- AI
  -- { "github/copilot.vim",
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     vim.api.nvim_set_keymap('i', '<C-y>', 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })
  --   end
  -- },

  { "augmentcode/augment.vim",
    config = function()
      -- Set up key mappings similar to copilot using vim commands
      vim.cmd([[
        " Use Ctrl-Y to accept a suggestion
        inoremap <c-y> <cmd>call augment#Accept()<cr>

        " Use enter to accept a suggestion, falling back to a newline if no suggestion is available
        " inoremap <cr> <cmd>call augment#Accept("\n")<cr>

        " Toggle Augment chat with <leader>a
        nnoremap <leader>ac :Augment chat<cr>
        vnoremap <leader>ac :Augment chat<CR>
        nnoremap <leader>at :Augment chat-toggle<CR>
      ]])
    end
  },

  { "chrisbra/csv.vim" },

  -- Markdown
  { "iamcco/markdown-preview.nvim", build = "cd app && npx --yes yarn install" },

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

  -- Lazy-load TypeScript tools only when needed
  { "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx"
    },
    config = function()
      -- Get LSP capabilities for TypeScript
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Common LSP setup
      local on_attach = function(client, bufnr)
        -- Disable formatting for all LSP clients - we use Prettier via conform.nvim instead
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gd', function() require("fzf-lua").lsp_definitions() end, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gr', function() require("fzf-lua").lsp_references() end, opts)
        -- Use conform for formatting
        vim.keymap.set('n', '<leader>f', function() require("conform").format({ async = true }) end, opts)

        -- Setup lsp_signature
        require("lsp_signature").on_attach({
          bind = true,
          handler_opts = { border = "rounded" },
          hint_enable = false,
          floating_window = false,
          always_trigger = false,
          close_timeout = 4000,
          toggle_key = '<C-k>',
          select_signature_key = '<C-n>',
        }, bufnr)
      end

      -- TypeScript-tools configuration
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          -- Disable formatting from the LSP
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          -- Attach all the regular mappings
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        settings = {
          -- Prefer relative imports
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "relative",
            importModuleSpecifierEnding = "minimal",
            quotePreference = "single",
          },
          -- Disable automatic organize imports on save
          tsserver_organize_imports_on_format = false,
          -- Disable formatting from tsserver
          typescript = { format = { enable = true } },
          javascript = { format = { enable = false } },
          -- Performance optimization settings
          complete_function_calls = false,
          include_completions_with_insert_text = false,
          disable_member_code_lens = true,
        },
        -- Performance settings
        separate_diagnostic_server = false,  -- Use single server for better startup time
        publish_diagnostic_on = "change",    -- Delay diagnostics to reduce stuttering
        expose_as_code_action = { "organize_imports", "remove_unused" },
        -- Disable formatting completely
        disable_formatting = true,
        -- Additional performance tweaks
        tsserver_max_memory = 2048,         -- Limit memory usage
      })

      -- Add TypeScript quick action mappings
      vim.keymap.set("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<CR>", { buffer = true, desc = "Organize Imports" })
      vim.keymap.set("n", "<leader>fa", "<cmd>TSToolsFixAll<CR>", { buffer = true, desc = "Fix All" })
      vim.keymap.set("n", "<leader>ru", "<cmd>TSToolsRemoveUnused<CR>", { buffer = true, desc = "Remove Unused" })
      vim.keymap.set("n", "<leader>rf", "<cmd>TSToolsRenameFile<CR>", { buffer = true, desc = "Rename current file with TS updates" })
    end
  }
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
vim.opt.hidden = true
vim.opt.buflisted = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.encoding = "utf-8"
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.formatoptions:append("cr")
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Set colorscheme
vim.cmd("colorscheme gruvbox")


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
vim.api.nvim_set_keymap('n', ',f', '<cmd>lua require("fzf-lua").git_files()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', ',r', '<cmd>lua require("fzf-lua").live_grep()<CR>', { noremap = true })

-- Expand %% to directory of current file in command mode
vim.api.nvim_set_keymap('c', '%%', [[<C-R>=expand('%:p:h').'/'<CR>]], { noremap = true })

-- FZF-Lua
vim.api.nvim_set_keymap('n', '<C-P>', '<cmd>lua require("fzf-lua").files()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>lua require("fzf-lua").buffers()<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<F3>', '<Esc><cmd>lua require("fzf-lua").buffers()<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<F3>', '<Esc><cmd>lua require("fzf-lua").buffers()<CR>', { noremap = true })

-- Better visual mode indenting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Copy/Paste
vim.api.nvim_set_keymap('v', '<C-C>', '"+yi', {})
vim.api.nvim_set_keymap('i', '<C-V>', '<Esc>"+gPi', {})
vim.api.nvim_set_keymap('i', '<S-Insert>', '<Esc>"+gPi', {})

-- Terminal escape
vim.api.nvim_set_keymap('t', '<C-v><Esc>', '<C-\\><C-n>', { noremap = true })

-- Create a global mapping that doesn't depend on leader key
vim.api.nvim_create_user_command('FormatBuffer', function()
  require("conform").format({ async = true, timeout_ms = 1000 })
end, {})

-- Map Ctrl+f to format in normal mode
vim.api.nvim_set_keymap('n', '<C-f>', ':FormatBuffer<CR>', { noremap = true, silent = true })

-- Custom commands
vim.api.nvim_create_user_command('FormatJSON', '%!python3 -m json.tool', {})

-- LSP Configuration

-- Common LSP setup
local on_attach = function(client, bufnr)
  -- Disable formatting for all LSP clients - we use Prettier via conform.nvim instead
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', function() require("fzf-lua").lsp_definitions() end, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', function() require("fzf-lua").lsp_implementations() end, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- signature help in insert mode too
  vim.keymap.set('n', '<leader>D', function() require("fzf-lua").lsp_typedefs() end, opts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', function() require("fzf-lua").lsp_code_actions() end, opts)
  vim.keymap.set('n', 'gr', function() require("fzf-lua").lsp_references({ jump_to_single_result = true }) end, opts)
  -- Use conform for formatting instead of LSP
  vim.keymap.set('n', '<leader>f', function() require("conform").format({ async = true }) end, opts)

  -- Diagnostics
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', function() require("fzf-lua").diagnostics_document() end, opts)
  vim.keymap.set('n', '<leader>Q', function() require("fzf-lua").diagnostics_workspace() end, opts)

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
  formatting = {
    format = function(entry, vim_item)
      -- Show source in completion menu
      local menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        cmdline = "[Cmd]",
      })[entry.source.name]

      vim_item.menu = menu
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
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

-- Enable command line completion only on Tab press, not automatically
local cmdline_mappings = cmp.mapping.preset.cmdline()

-- Add custom mappings for command-line mode
cmdline_mappings['<C-j>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end, {'c'})

cmdline_mappings['<C-k>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end, {'c'})

cmdline_mappings['<Down>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end, {'c'})

cmdline_mappings['<Up>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end, {'c'})

cmp.setup.cmdline(':', {
  mapping = cmdline_mappings,
  sources = {
    { name = 'cmdline' }
  },
  completion = {
    autocomplete = false -- Only show completion when requested
  }
})

-- Setup LSP capabilities with nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Initialize language servers
-- TS configuration moved to the lazy-loading configuration above
-- IMPORTANT: Don't remove this comment section - it reminds you where the TS config now lives

-- ESLint LSP setup - will only activate in projects with ESLint config
vim.lsp.config.eslint = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  -- Only start ESLint when a config file is found (excluding node_modules)
  root_markers = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.json',
    '.eslintrc.yml',
    '.eslintrc.yaml',
    '.eslintrc.cjs',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts'
  },
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Diagnostic config similar to coc but optimized for performance
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
    focusable = true, -- Make float windows focusable to allow scrolling
    source = 'always',
    header = '',
    prefix = '',
    border = 'rounded',
    max_width = 80,   -- Set maximum width to prevent wrapping
    format = function(diagnostic)
      -- Return full diagnostic message without truncation
      if diagnostic.message then
        return diagnostic.message
      end
      return diagnostic
    end,
  },
  -- Performance improvements
  update_on_change = false,  -- Only update diagnostics on InsertLeave and BufWrite
  underline = {
    severity = { min = vim.diagnostic.severity.WARN }  -- Only underline warnings and errors
  },
})

-- Configure diagnostics with custom signs
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "ℹ" }
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.INFO] = signs.Info,
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = "", -- Optional: Matches your original empty numhl
  },
})

-- Custom diagnostic navigation that silently does nothing when no diagnostics exist
local goto_next = function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics > 0 then
    vim.diagnostic.goto_next({
      float = false,    -- Don't show floating window
      severity_sort = true,
    })
  end
end

local goto_prev = function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics > 0 then
    vim.diagnostic.goto_prev({
      float = false,    -- Don't show floating window
      severity_sort = true,
    })
  end
end

-- Default diagnostic float function
local open_diagnostic_float = function()
  vim.diagnostic.open_float({ scope = "cursor" })
end

-- Expanded diagnostic float with full width
local open_full_diagnostic_float = function()
  local current_diagnostic = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })[1]
  if current_diagnostic then
    vim.api.nvim_open_win(
      vim.api.nvim_create_buf(false, true),
      true,
      {
        relative = "editor",
        width = vim.o.columns - 4,
        height = math.max(5, math.min(20, vim.o.lines - 10)),
        row = math.min(5, vim.o.lines / 2 - 5),
        col = 2,
        style = "minimal",
        border = "rounded",
        title = "Full Error Message",
        title_pos = "center",
      }
    )

    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(current_diagnostic.message, "\n"))
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    -- Add keymaps to close window
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
  else
    vim.notify("No diagnostic at cursor position", vim.log.levels.INFO)
  end
end

vim.keymap.set('n', ']g', goto_next, { noremap = true, silent = true })
vim.keymap.set('n', '[g', goto_prev, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', open_diagnostic_float, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>E', open_full_diagnostic_float, { noremap = true, silent = true, desc = "Show full error message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Setup conform.nvim for formatting
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    html = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    yaml = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
    lua = { "trim_whitespace" },
  },

  formatters = {
    trim_whitespace = {
      command = "sed",
      args = { "-i", "'s/\\s\\+$//'" },
      stdin = false,
    },
  },
  -- format_on_save = {
  --   lsp_fallback = true,
  -- },

  -- Use faster formatters first
  format_after_save = function(bufnr)
    -- If a large file, don't format on save
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return
    end
    return { lsp_fallback = false }
  end,
})

-- Create user command for manual format (async by default)
vim.api.nvim_create_user_command('Format', function()
  require("conform").format({
    async = true,
    lsp_fallback = true,
    timeout_ms = 1000,
  })
end, {})

-- TreeSitter configuration with optimized performance
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "javascript", "typescript", "tsx", "json", "html", "css",
    "lua", "vim", "vimdoc", "bash", "markdown", "markdown_inline"
  },
  -- Improve startup time by delaying parser installations
  sync_install = false,
  -- Only install parsers when actually needed
  auto_install = false,  -- Disable automatic installation for better control

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- Disable slow modules
    disable = function(lang, bufnr)
      -- Disable for large files
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      return false
    end,
  },

  indent = {
    enable = true,
  },

  -- Incremental selection based on the named nodes from the grammar
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-Space>",
      node_incremental = "<C-Space>",
      scope_incremental = "<nop>",
      node_decremental = "<bs>",
    },
  },

  -- Text objects for selections, movements, swaps, and more
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
  },
})


-- TypeScript-specific commands
vim.api.nvim_create_user_command('OrganizeImports', function()
  vim.cmd('TSToolsOrganizeImports')
end, {})

vim.api.nvim_create_user_command('FixAll', function()
  vim.cmd('TSToolsFixAll')
end, {})

-- Helper command to install formatter daemons
vim.api.nvim_create_user_command('InstallFormatters', function()
  -- Install formatters
  vim.fn.system('npm install -g prettier@latest @fsouza/prettierd@latest')
  -- Check if installation was successful
  local exitcode_prettierd = vim.fn.system('command -v prettierd >/dev/null 2>&1 && echo $?')
  local exitcode_prettier = vim.fn.system('command -v prettier >/dev/null 2>&1 && echo $?')

  -- Report results
  if exitcode_prettierd == "0\n" and exitcode_prettier == "0\n" then
    print("✅ Formatters installed successfully!")
    print("prettierd and prettier are now available globally")
  else
    print("❌ Some formatters failed to install. Please check npm errors.")
    -- Try to diagnose the issue
    if exitcode_prettierd ~= "0\n" then
      print("prettierd installation issue. Trying fallback installation...")
      vim.fn.system('npm install -g @fsouza/prettierd')
      local retry = vim.fn.system('command -v prettierd >/dev/null 2>&1 && echo $?')
      if retry == "0\n" then
        print("✅ prettierd installed successfully on second attempt")
      else
        print("❌ prettierd installation failed. Try manually: npm install -g @fsouza/prettierd")
      end
    end
  end
end, {})

-- Helper command to install TreeSitter parsers
vim.api.nvim_create_user_command('TSInstall', function(opts)
  local parser = opts.args
  if parser == "" then
    print("Please specify a parser to install, or use :TSUpdate to update all parsers")
    return
  end
  vim.cmd('TSInstall ' .. parser)
end, { nargs = '?' })


-- TypeScript/JavaScript setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    -- Use smartindent for basic brace indenting
    vim.bo.smartindent = true
    vim.bo.cindent = false  -- Disable cindent for TS/JS
    vim.bo.cinoptions = ""  -- Clear cinoptions
    vim.bo.autoindent = true  -- Ensure autoindent is enabled
    
    -- Custom indent expression to handle empty lines properly
    vim.bo.indentexpr = "GetTSIndent()"
    
    -- Define the custom indent function
    vim.cmd([[
      function! GetTSIndent()
        let lnum = prevnonblank(v:lnum - 1)
        
        " No previous line
        if lnum == 0
          return 0
        endif
        
        let line = getline(lnum)
        let ind = indent(lnum)
        
        " Increase indent after opening brace/bracket/paren or arrow function
        " Matches: { or [ or ( at end, => {, or : { (for TypeScript return types)
        if line =~ '[{(\[][\s,]*$' || line =~ '=>\s*{\s*$' || line =~ ':\s*{\s*$'
          return ind + shiftwidth()
        endif
        
        " Current line closes brace/bracket/paren - decrease indent
        if getline(v:lnum) =~ '^\s*[}\]\)]'
          return ind - shiftwidth()
        endif
        
        " Default: use same indent as previous non-blank line
        return ind
      endfunction
    ]])

    -- Keymaps
    vim.keymap.set("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<CR>", { buffer = true, desc = "Organize Imports" })
    vim.keymap.set("n", "<leader>fa", "<cmd>TSToolsFixAll<CR>", { buffer = true, desc = "Fix All" })
    vim.keymap.set("n", "<leader>ru", "<cmd>TSToolsRemoveUnused<CR>", { buffer = true, desc = "Remove Unused" })
  end,
})
