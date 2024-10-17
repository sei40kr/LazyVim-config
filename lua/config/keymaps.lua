-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "[<Space>", function()
  local lines = vim.fn["repeat"]({ "" }, vim.v.count1)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, true, lines)
end, { desc = "Add blank lines above" })
vim.keymap.set("n", "]<Space>", function()
  local lines = vim.fn["repeat"]({ "" }, vim.v.count1)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line, current_line, true, lines)
end, { desc = "Add blank lines below" })
