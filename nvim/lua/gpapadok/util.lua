-- Utilities

return {
  tbl_print = function(t)
    print(vim.inspect(t))
  end,

  keymaps_set = function(keys, opts)
    for _, km in pairs(keys) do
      vim.keymap.set(km[1], km[2], km[3], vim.tbl_extend('force', opts, km[4]))
    end
  end,

  array_if = function(condition, map)
    if condition then
      return map
    else
      return {}
    end
  end,

  trim_trailing_whitespace = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd('%s/[[:space:]]*$//g')
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
}
