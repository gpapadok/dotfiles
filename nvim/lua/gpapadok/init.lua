vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Helpers
local helpers = require("gpapadok.util")

-- Keymaps
local keys = require("gpapadok.keymaps")
helpers.keymaps_set(keys.keymaps, keys.default_opts)

-- General configuration
local config = require("gpapadok.config")
vim.diagnostic.config(config.diagnostic_config)

for name, cfg in pairs(config.lsp_overrides) do
  vim.lsp.config(name, cfg)
end

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
