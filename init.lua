local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.vim/plugged')

Plug('junegunn/fzf')
Plug('junegunn/fzf.vim')

Plug('AndrewRadev/splitjoin.vim')

Plug('ap/vim-css-color')

Plug('ctrlpvim/ctrlp.vim')

vim.call('plug#end')

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
