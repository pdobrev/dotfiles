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
  { "neoclide/coc.nvim", branch = "release" },
  
  { "mhartington/formatter.nvim" },
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


-- COC Configuration
vim.g.coc_global_extensions = {
  'coc-tsserver',
  'coc-prettier',
  'coc-pyright',
  'coc-json',
  'coc-eslint',
}

-- COC settings
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"

-- Functions
vim.cmd([[
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
]])

-- COC key mappings
vim.api.nvim_set_keymap('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>"', { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\\<Tab>" : coc#refresh()', { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-h>"', { expr = true })

vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })
vim.api.nvim_set_keymap('n', 'K', ':call ShowDocumentation()<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<F2>', '<Plug>(coc-rename)', {})
vim.api.nvim_set_keymap('x', '<leader>f', '<Plug>(coc-format-selected)', {})
vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>(coc-format-selected)', {})
vim.api.nvim_set_keymap('x', '<leader>a', '<Plug>(coc-codeaction-selected)', {})
vim.api.nvim_set_keymap('n', '<leader>a', '<Plug>(coc-codeaction-selected)', {})
vim.api.nvim_set_keymap('n', '<leader>ac', '<Plug>(coc-codeaction)', {})
vim.api.nvim_set_keymap('n', '<leader>qf', '<Plug>(coc-fix-current)', {})
vim.api.nvim_set_keymap('x', 'if', '<Plug>(coc-funcobj-i)', {})
vim.api.nvim_set_keymap('x', 'af', '<Plug>(coc-funcobj-a)', {})
vim.api.nvim_set_keymap('o', 'if', '<Plug>(coc-funcobj-i)', {})
vim.api.nvim_set_keymap('o', 'af', '<Plug>(coc-funcobj-a)', {})

-- COC autocmds
vim.api.nvim_exec([[
  augroup CocGroup
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end
]], true)

-- COC commands
vim.api.nvim_create_user_command('Format', 'call CocAction("format")', {})
vim.api.nvim_create_user_command('Fold', 'call CocAction("fold", <f-args>)', { nargs = '?' })
vim.api.nvim_create_user_command('OR', 'call CocAction("runCommand", "editor.action.organizeImport")', {})

-- COC lists
vim.api.nvim_set_keymap('n', '<space>a', ':<C-u>CocList diagnostics<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>e', ':<C-u>CocList extensions<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>c', ':<C-u>CocList commands<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>o', ':<C-u>CocList outline<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>s', ':<C-u>CocList -I symbols<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>j', ':<C-u>CocNext<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>k', ':<C-u>CocPrev<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<space>p', ':<C-u>CocListResume<CR>', { silent = true, noremap = true })