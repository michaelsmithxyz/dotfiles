-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.signcolumn = 'yes'

vim.opt.mouse = 'a'

vim.api.nvim_set_option("clipboard","unnamedplus")

vim.opt.showmode = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 750

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how vim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimum number of lines to display around the cursor
vim.opt.scrolloff = 10

vim.keymap.set("i", "<S-Tab>", "<C-d>")
vim.keymap.set("n", "<leader>n", ":bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>p", ":bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>d", ":bdelete<cr>", { desc = "Close buffer" })

require("config.local").load()

require("config.lazy")
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
