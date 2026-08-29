vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Helpers
local helpers = require("gpapadok.util")
for k, v in pairs(helpers) do
  vim.fn[k] = v
end

-- Keymaps
local keys = require("gpapadok.keymaps")
vim.fn.keymaps_set(keys.keymaps, keys.default_opts)

-- General configuration
local config = require("gpapadok.config")
vim.diagnostic.config(config.diagnostic_config)

vim.lsp.config('*', {
  root_markers = { '.git' },
  on_attach = function(_, bufnr)
    print('Attaching to language server')
    -- vim.fn.keymaps_set(
    --   general_config.keys.keymaps,
    --   vim.tbl_extend('force', general_config.keys.default_opts, { buffer = bufnr })
    -- )
  end,
})

-- vue is lost during merge with the default settings if we put filetypes in vtsls.lua
vim.lsp.config('vtsls', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
})

vim.lsp.enable(config.language_servers)

for _, command in pairs(config.commands) do
  vim.cmd(command)
end

-- Lazy
require("gpapadok.lazy")

-- Options
local options = require("gpapadok.options")
for k, v in pairs(options) do
  vim.opt[k] = v
end
