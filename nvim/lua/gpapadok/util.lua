-- Utilities

vim.fn.tbl_print = function(t)
  print(vim.inspect(t))
end

vim.fn.keymaps_set = function(keys, opts)
  for _, km in pairs(keys) do
    vim.keymap.set(km[1], km[2], km[3], vim.tbl_extend('force', opts, km[4]))
  end
end

vim.fn.array_if = function(condition, map)
  if condition then
    return map
  else
    return {}
  end
end
