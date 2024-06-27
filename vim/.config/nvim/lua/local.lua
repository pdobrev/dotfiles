-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.netrw_browser_viewer = 'open'


-- empty setup using defaults
require("nvim-tree").setup()

-- Format Swift on save.
require('formatter').setup({
  filetype = {
    swift = {
      -- SwiftFormat
      function()
        return {
          exe = "swiftformat",
          args = {},
          stdin = true
        }
      end
    }
  }
})

vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.swift FormatWrite
  augroup END
]], true)
