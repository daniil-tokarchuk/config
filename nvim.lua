local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        git = {
          enable = false,
        },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
      })
    end,
  },
})

-- Set tab size to 2 spaces
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.shiftwidth = 2     -- Number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 2        -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 2    -- Number of spaces that a <Tab> counts for while editing

-- Set Ctrl + d and Ctrl + u to jump 10 lines
vim.opt.scroll = 10

-- Enable undo history between sessions
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true -- Show absolute line number for the current line

vim.keymap.set('n', '?', ':nohlsearch<CR>', { silent = true })

-- Remap redo to Shift + U
vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true, silent = true })

-- Keybinding for opening the file tree
vim.api.nvim_set_keymap('n', 't', ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Keybinding for toggling comments
vim.api.nvim_set_keymap('n', 'c', "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'c', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { noremap = true, silent = true })

-- Keybinding for Telescope
vim.api.nvim_set_keymap('n', ' f', ":Telescope live_grep<CR>", { noremap = true, silent = true }) -- Find in files
vim.api.nvim_set_keymap('n', ' g', ":Telescope find_files<CR>", { noremap = true, silent = true }) -- Find files
