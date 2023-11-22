local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.vim/plugged')

Plug('junegunn/fzf')
Plug('junegunn/fzf.vim')

-- Go
Plug('nvim-treesitter/nvim-treesitter')
-- Plug('neovim/nvim-lspconfig')
-- Plug 'ray-x/go.nvim'
-- Plug 'ray-x/guihua.lua'

-- Autocompletion
--Plug('hrsh7th/nvim-cmp')        -- Required
--Plug('hrsh7th/cmp-nvim-lsp')    -- Required
--Plug('L3MON4D3/LuaSnip')        -- Required
--
Plug('fatih/vim-go', {['do'] = vim.cmd['GoUpdateBinaries']})

--Plug('VonHeikemen/lsp-zero.nvim', {branch = 'v2.x'})

Plug('AndrewRadev/splitjoin.vim')

Plug('ap/vim-css-color')

Plug('ctrlpvim/ctrlp.vim')
--Plug('SirVer/ultisnips')

vim.call('plug#end')

--local lsp = require('lsp-zero').preset({})
--
--lsp.on_attach(function(client, bufnr)
--    lsp.default_keymaps({buffer = bufnr})
--end)
--
--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
--
--lsp.setup()

--require'nvim-treesitter.configs'.setup {
--  highlight = {
--    enable = true,
--    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--    -- Using this option may slow down your editor, and you may see some duplicate highlights.
--    -- Instead of true it can also be a list of languages
--    additional_vim_regex_highlighting = false,
--  },
--  incremental_selection = {
--    enable = true,
--    keymaps = {
--      init_selection = "gnn", -- set to `false` to disable one of the mappings
--      node_incremental = "grn",
--      scope_incremental = "grc",
--      node_decremental = "grm",
--    },
--  },
--}

vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_function_parameters = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_variable_assignments = 1
vim.g.go_highlight_variable_declarations = 1
vim.g.go_highlight_array_whitespace_error = 1
vim.g.go_highlight_chan_whitespace_error = 1
vim.g.go_highlight_space_tab_error = 1
vim.g.go_highlight_trailing_whitespace_error = 1
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_generate_tags = 1
vim.g.go_highlight_format_strings = 1
vim.g.go_highlight_diagnostic_errors = 1
vim.g.go_highlight_diagnostic_warnings = 1

vim.g.go_auto_sameids = 1

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
