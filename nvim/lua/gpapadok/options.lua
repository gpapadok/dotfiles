vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.wrap = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true

-- vim.opt.hlsearch = true
-- vim.opt.mouse = 'a'

vim.fn.trim_trailing_whitespace = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('%s/[[:space:]]*$//g')
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end

vim.cmd('au BufWrite * lua vim.fn.trim_trailing_whitespace()')

