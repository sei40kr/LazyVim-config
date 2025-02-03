-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { ".git", "cwd" }

vim.g.lazyvim_python_lsp = "basedpyright"

local opt = vim.opt

-- FIXME: 'swapfile' causes nil reference errors in Neovim 0.11. neovim/neovim#33224
opt.swapfile = false
