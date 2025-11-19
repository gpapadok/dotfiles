vim.keymap.set('v', '<leader>l', function() return ':lua<cr>' end, {
  desc = 'Evaluate selection as lua',
  expr = true,
})

vim.keymap.set('n', '<leader>h', function()
  vim.cmd('h ' .. vim.fn.input('Doc: '))
end, { desc = 'Help' })
