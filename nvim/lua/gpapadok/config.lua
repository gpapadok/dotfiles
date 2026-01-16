local general_config = {
  language_servers = { 'lua_ls', 'pyright' },
  diagnostic_config = {
    -- Don't set both to true
    virtual_text = true,
    virtual_lines = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '⚠',
        [vim.diagnostic.severity.WARN] = '!',
        [vim.diagnostic.severity.HINT] = '?',
        [vim.diagnostic.severity.INFO] = 'I',
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      },
      numhl = {
        [vim.diagnostic.severity.WARN] = 'WarningMsg',
      },
    },
  },
  keys = {
    keymaps = {
      { "n", "<leader>w", "<cmd>write<cr>", { desc = "Save" } },
      { "n", "<leader>s", "<cmd>source $MYVIMRC<cr>", { desc = "Load init file" } },

      { { "v", "x" }, "gy", '"+y', { desc = "Yank to clipboard" } },
      { { "n", "x" }, "gp", '"+p', { desc = "Paste from clipboard" } },

      { "n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" } },
      { "n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" } },
      -- { "n", "<leader>k", "<cmd>Telescope lsp_references<cr>", { desc = "Show LSP references" } },
      { "n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" } },
      -- { "n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Show LSP definitions" } },
      -- { "n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Show LSP implementations" } },
      -- { "n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Show LSP type definitions" } },

      { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions"} },
      { "n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" } },
      -- { "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Show buffer diagnostics" } },
      { "n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" } },
      { "n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Go to previous diagnostic" } },
      { "n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Go to next diagnostic" } },
      { "n", "K", vim.lsp.buf.hover, { desc = "Show documentation at point" } },
      { "n", "<leader>rs", ":LspRestart<cr>", { desc = "Restart LSP" } },
    },
    default_opts = { noremap = true, silent = true },
  },
}


vim.diagnostic.config(general_config.diagnostic_config)

vim.lsp.config('*', {
  root_markers = { '.git' },
  on_attach = function(_, bufnr)
    print('Attaching to language server')
    vim.fn.keymaps_set(
      general_config.keys.keymaps,
      vim.tbl_extend('force', general_config.keys.default_opts, { buffer = bufnr })
    )
  end,
})

vim.lsp.enable(general_config.language_servers)
