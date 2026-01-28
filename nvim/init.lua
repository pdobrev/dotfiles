-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeOpen" },
    keys = {
      { ",d", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { ",n", "<cmd>NvimTreeFindFile<CR>", desc = "Find file in tree" },
    },
    config = function() require("nvim-tree").setup() end
  },
  -- TreeSitter for better syntax highlighting and code understanding
  { "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
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
    cmd = "FzfLua",
    keys = {
      { ",f", function() require("fzf-lua").git_files() end, desc = "Find git files" },
      { ",r", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<C-P>", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<F3>", function() require("fzf-lua").buffers() end, mode = { "n", "v", "i" }, desc = "List buffers" },
    },
    config = function()
      require("fzf-lua").setup({
        -- Use system fzf
        fzf_bin = 'fzf',
        winopts = {
          preview = {
            default = "builtin",
            delay = 150,       -- Delay preview until file list loads first
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
          -- cmd = "fd --color=never --type f --hidden --follow --exclude .git --max-depth 10",
          cmd = "fd --color=never --type f --hidden --exclude .git --max-depth 10",
          multiprocess = true, -- Speed up file operations
          max_results = 100,   -- Limit results for faster display
          file_icons = false,  -- Disable file icons
          git_file_shared_list = true, -- Share file list with git_files
          use_cache = true,   -- Cache results for reuse
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --hidden --follow --glob '!.git'",
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
  { "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        padding = true,        -- Add space after comment delimiter (like NERDSpaceDelims = 1)
        sticky = true,
        ignore = nil,
        toggler = {
          line = 'gcc',        -- Normal mode toggle
          block = 'gbc',
        },
        opleader = {
          line = 'gc',         -- Visual mode toggle
          block = 'gb',
        },
        extra = {
          above = 'gcO',
          below = 'gco',
          eol = 'gcA',
        },
        mappings = {
          basic = true,
          extra = true,
        },
      })
    end
  },


  -- AI
  { "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', { silent = true, expr = true, replace_keycodes = false, desc = "Accept Copilot suggestion" })
    end
  },

  -- { "augmentcode/augment.vim",
  --   config = function()
  --     -- Set up key mappings similar to copilot using vim commands
  --     vim.cmd([[
  --       " Use Ctrl-Y to accept a suggestion
  --       inoremap <c-y> <cmd>call augment#Accept()<cr>

  --       " Use enter to accept a suggestion, falling back to a newline if no suggestion is available
  --       " inoremap <cr> <cmd>call augment#Accept("\n")<cr>

  --       " Toggle Augment chat with <leader>a
  --       nnoremap <leader>ac :Augment chat<cr>
  --       vnoremap <leader>ac :Augment chat<CR>
  --       nnoremap <leader>at :Augment chat-toggle<CR>
  --     ]])
  --   end
  -- },

  { "chrisbra/csv.vim" },

  -- Markdown
  { "iamcco/markdown-preview.nvim", build = "cd app && npx --yes yarn install" },

  -- LSP and completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
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

      -- Cmdline completion
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
      })

      local cmdline_mappings = cmp.mapping.preset.cmdline()
      cmdline_mappings['<C-j>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item() else fallback() end
      end, {'c'})
      cmdline_mappings['<C-k>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item() else fallback() end
      end, {'c'})
      cmdline_mappings['<Down>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item() else fallback() end
      end, {'c'})
      cmdline_mappings['<Up>'] = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item() else fallback() end
      end, {'c'})

      cmp.setup.cmdline(':', {
        mapping = cmdline_mappings,
        sources = { { name = 'cmdline' } },
        completion = { autocomplete = false }
      })
    end,
  },
  { "stevearc/conform.nvim", cmd = { "Format", "FormatBuffer" }, event = "BufWritePre" },
  { "ray-x/lsp_signature.nvim", event = "LspAttach" },

  -- CtrlSF
  -- lua/plugins/ctrlsf.lua
  {
    "dyng/ctrlsf.vim",
    cmd = { "CtrlSF", "CtrlSFOpen", "CtrlSFToggle" },

    -- Set options BEFORE the plugin loads
    init = function()
      vim.g.ctrlsf_default_root = "project" -- use VCS root when no path is given
      vim.g.ctrlsf_search_mode = "async"    -- async search (nice UX in big repos)
      vim.g.ctrlsf_position = "left"
      vim.g.ctrlsf_winsize = "30%"
      vim.g.ctrlsf_case_sensitive = "smart" -- default in plugin

      -- keep the results window open when jumping around (optional, but handy)
      vim.g.ctrlsf_auto_close = { normal = 0, compact = 0 }
    end,

    keys = {
      -- “Search in files…” prompt
      { "<leader>sf", "<Plug>CtrlSFPrompt", mode = "n", remap = true, desc = "CtrlSF: search (prompt)" },

      -- Search word under cursor (fills pattern + waits for optional path/args)
      { "<leader>sw", "<Plug>CtrlSFCwordPath", mode = "n", remap = true, desc = "CtrlSF: search word under cursor" },

      -- Visual selection search
      { "<leader>sv", "<Plug>CtrlSFVwordPath", mode = "v", remap = true, desc = "CtrlSF: search visual selection" },

      -- Reopen/toggle results window without re-running the search
      { "<leader>so", "<cmd>CtrlSFOpen<CR>", desc = "CtrlSF: open results window" },
      { "<leader>st", "<cmd>CtrlSFToggle<CR>", desc = "CtrlSF: toggle results window" },
    },
  }
})

-- Performance settings
vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.opt.updatetime = 300

-- General settings
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes" -- Always show the sign column to prevent text shifting

-- Create directory for swap files if it doesn't exist
local swap_dir = vim.fn.expand("~/.vim/tmp")
if vim.fn.isdirectory(swap_dir) == 0 then
  vim.fn.mkdir(swap_dir, "p")
end

vim.opt.directory = swap_dir
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


-- Comment.nvim is configured in the plugin spec above

-- Key mappings
vim.keymap.set('n', ',v', ':e ~/.config/nvim/init.lua<CR>', { desc = "Edit nvim config" })

-- Unmap F1 to prevent accidental help opening
vim.keymap.set({'n', 'i', 'v', 'c', 'o'}, '<F1>', '<Nop>', { desc = "Disabled" })

-- Add autocmd to reload config when saved
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~/.config/nvim/init.lua"),
  command = "source <afile>",
})

-- Expand %% to directory of current file in command mode
vim.keymap.set('c', '%%', [[<C-R>=expand('%:p:h').'/'<CR>]], { desc = "Expand to file dir" })

-- Better visual mode indenting
vim.keymap.set('v', '<', '<gv', { desc = "Indent left and reselect" })
vim.keymap.set('v', '>', '>gv', { desc = "Indent right and reselect" })

-- Copy/Paste
vim.keymap.set('v', '<C-C>', '"+yi', { desc = "Copy to clipboard" })
vim.keymap.set('i', '<C-V>', '<Esc>"+gPi', { desc = "Paste from clipboard" })
vim.keymap.set('i', '<S-Insert>', '<Esc>"+gPi', { desc = "Paste from clipboard" })

-- Terminal escape
vim.keymap.set('t', '<C-v><Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })

-- Create a global mapping that doesn't depend on leader key
vim.api.nvim_create_user_command('FormatBuffer', function()
  require("conform").format({ async = true, timeout_ms = 1000 })
end, {})

-- Map Ctrl+f to format in normal mode
vim.keymap.set('n', '<C-f>', ':FormatBuffer<CR>', { silent = true, desc = "Format buffer" })

-- Custom commands
vim.api.nvim_create_user_command('FormatJSON', '%!python3 -m json.tool', {})

-- LSP Configuration

-- Common LSP setup
local on_attach = function(client, bufnr)
  -- Disable formatting for all LSP clients - we use Prettier via conform.nvim instead
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function with_desc(desc)
    return vim.tbl_extend("force", opts, { desc = desc })
  end
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, with_desc("Go to declaration"))
  vim.keymap.set('n', 'gd', function() require("fzf-lua").lsp_definitions() end, with_desc("Go to definition"))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, with_desc("Hover documentation"))
  vim.keymap.set('n', 'gi', function() require("fzf-lua").lsp_implementations() end, with_desc("Go to implementation"))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, with_desc("Signature help"))
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, with_desc("Signature help"))
  vim.keymap.set('n', '<leader>D', function() require("fzf-lua").lsp_typedefs() end, with_desc("Go to type definition"))
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, with_desc("Rename symbol"))
  vim.keymap.set('n', '<leader>ca', function() require("fzf-lua").lsp_code_actions() end, with_desc("Code actions"))
  vim.keymap.set('n', 'gr', function() require("fzf-lua").lsp_references({ jump1 = true }) end, with_desc("Find references"))
  -- Use conform for formatting instead of LSP
  vim.keymap.set('n', '<leader>f', function() require("conform").format({ async = true }) end, with_desc("Format buffer"))

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

-- Setup LSP capabilities with nvim-cmp (loaded lazily, so use a function)
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Extend with cmp capabilities when available
local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Initialize language servers
-- Load nvim-lspconfig to register server configurations (required for vim.lsp.config)
require('lspconfig')

-- TypeScript language server setup using vim.lsp.config
vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "relative",
        quotePreference = "single",
      },
    },
    javascript = {
      preferences = {
        importModuleSpecifier = "relative",
        quotePreference = "single",
      },
    },
  },
}

vim.lsp.enable('ts_ls')

-- ESLint LSP setup using vim.lsp.config
vim.lsp.config.eslint = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = {
    '.eslintrc', '.eslintrc.js', '.eslintrc.json', '.eslintrc.yml', '.eslintrc.yaml', '.eslintrc.cjs',
    'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs', 'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts'
  },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    eslint = {
      useFlatConfig = true,
      workingDirectories = { { mode = "auto" } },
    }
  },
}

vim.lsp.enable('eslint')

-- Diagnostic config
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "ℹ" }
vim.diagnostic.config({
  virtual_text = {
    prefix = '■',
    spacing = 2,
  },
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
    numhl = "",
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = true,
    source = 'always',
    header = '',
    prefix = '',
    border = 'rounded',
    max_width = 80,
    format = function(diagnostic)
      if diagnostic.message then
        return diagnostic.message
      end
      return diagnostic
    end,
  },
  update_on_change = false,
})

-- Custom diagnostic navigation that silently does nothing when no diagnostics exist
local goto_next = function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics > 0 then
    vim.diagnostic.goto_next({
      float = false,
      severity_sort = true,
    })
  end
end

local goto_prev = function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics > 0 then
    vim.diagnostic.goto_prev({
      float = false,
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
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(current_diagnostic.message, "\n"))
    vim.bo[buf].modifiable = false

    -- Add keymaps to close window
    vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true, desc = "Close window" })
    vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true, desc = "Close window" })
  else
    vim.notify("No diagnostic at cursor position", vim.log.levels.INFO)
  end
end

vim.keymap.set('n', '[g', goto_prev, { noremap = true, silent = true, desc = "Previous diagnostic" })
vim.keymap.set('n', ']g', goto_next, { noremap = true, silent = true, desc = "Next diagnostic" })
vim.keymap.set('n', '<leader>e', open_diagnostic_float, { noremap = true, silent = true, desc = "Show diagnostic float" })
vim.keymap.set('n', '<leader>E', open_full_diagnostic_float, { noremap = true, silent = true, desc = "Show full error message" })
vim.keymap.set('n', '<leader>q', function() require("fzf-lua").diagnostics_document() end, { noremap = true, silent = true, desc = "Document diagnostics" })
vim.keymap.set('n', '<leader>Q', function() require("fzf-lua").diagnostics_workspace() end, { noremap = true, silent = true, desc = "Workspace diagnostics" })


local js_like_formatters = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

-- Setup conform.nvim for formatting
require("conform").setup({
  formatters_by_ft = {
    javascript = js_like_formatters,
    typescript = js_like_formatters,
    javascriptreact = js_like_formatters,
    typescriptreact = js_like_formatters,
    css = js_like_formatters,
    html = js_like_formatters,
    json = js_like_formatters,
    yaml = js_like_formatters,
    markdown = js_like_formatters,
    lua = { "trim_whitespace" },
  },

  formatters = {
    -- Pending on https://github.com/oxc-project/oxc/issues/14720 getting fixed.
    oxfmt = {
      command = "oxfmt",
      args = { "$FILENAME" },
      stdin = false,
      -- If we want to only run oxfmt is there's an .oxfmtrc.json, uncomment this.
      -- condition = function(ctx)
      --   return vim.fs.find(".oxfmtrc.json", { path = ctx.filename, upward = true })[1] ~= nil
      -- end,
      -- When stdin=false, use this template to generate the temporary file that gets formatted
      tmpfile_format = "/tmp/.conform.$RANDOM.$FILENAME",
    },

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
    local name = vim.api.nvim_buf_get_name(bufnr)
    -- If a large file, don't format on save
    local max_filesize = 512 * 1024 -- 512 KB
    local ok, stats = pcall(vim.uv.fs_stat, name)
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
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
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


-- TypeScript-specific commands (for ts_ls)
vim.api.nvim_create_user_command('OrganizeImports', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports.ts" },
      diagnostics = {},
    },
  })
end, {})

vim.api.nvim_create_user_command('FixAll', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.fixAll.ts" },
      diagnostics = {},
    },
  })
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

-- Custom indent function for TS/JS (defined globally for indentexpr)
function _G.GetTSIndent()
  local lnum = vim.fn.prevnonblank(vim.v.lnum - 1)

  -- No previous line
  if lnum == 0 then
    return 0
  end

  local line = vim.fn.getline(lnum)
  local ind = vim.fn.indent(lnum)
  local sw = vim.fn.shiftwidth()

  -- Increase indent after opening brace/bracket/paren or arrow function
  -- Matches: { or [ or ( at end, => {, or : { (for TypeScript return types)
  if vim.fn.match(line, "[\\[{(][\\s,]*$") >= 0
    or vim.fn.match(line, "=>\\s*{\\s*$") >= 0
    or vim.fn.match(line, ":\\s*{\\s*$") >= 0 then
    return ind + sw
  end

  -- Current line closes brace/bracket/paren - decrease indent
  local current_line = vim.fn.getline(vim.v.lnum)
  if vim.fn.match(current_line, "^\\s*[\\]})]") >= 0 then
    return ind - sw
  end

  -- Default: use same indent as previous non-blank line
  return ind
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    -- Use smartindent for basic brace indenting
    vim.bo.smartindent = true
    vim.bo.cindent = false  -- Disable cindent for TS/JS
    vim.bo.cinoptions = ""  -- Clear cinoptions
    vim.bo.autoindent = true  -- Ensure autoindent is enabled

    -- Custom indent expression to handle empty lines properly
    vim.bo.indentexpr = "v:lua.GetTSIndent()"

    -- Keymaps for TypeScript
    vim.keymap.set("n", "<leader>oi", "<cmd>OrganizeImports<CR>", { buffer = true, desc = "Organize Imports" })
    vim.keymap.set("n", "<leader>fa", "<cmd>FixAll<CR>", { buffer = true, desc = "Fix All" })
    vim.keymap.set("n", "<leader>ru", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.removeUnused.ts" },
          diagnostics = {},
        },
      })
    end, { buffer = true, desc = "Remove Unused" })
  end,
})
