return {
  keymaps = {
    { "n", "<leader>w", "<cmd>write<cr>", { desc = "Save" } },
    { "n", "<leader>s", "<cmd>source $MYVIMRC<cr>", { desc = "Load init file" } },

    { { "v", "x" }, "gy", '"+y', { desc = "Yank to clipboard" } },
    { { "n", "x" }, "gp", '"+p', { desc = "Paste from clipboard" } },

    { "n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" } },
    { "n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" } },
    { "n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" } },
    { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions"} },
    { "n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" } },
    -- { "n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" } },
    { "n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Go to previous diagnostic" } },
    { "n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Go to next diagnostic" } },
    { "n", "K", vim.lsp.buf.hover, { desc = "Show documentation at point" } },
    { "n", "<leader>rs", ":LspRestart<cr>", { desc = "Restart LSP" } },

    {
      "v",
      "<leader>l",
      function() return ':lua<cr>' end,
      {
        desc = 'Evaluate selection as lua',
        expr = true,
      },
    },
    {
      "n",
      "<leader>h",
      function()
        vim.cmd('h ' .. vim.fn.input('Doc: '))
      end,
      { desc = "Help" },
    },
  },
  default_opts = { noremap = true, silent = true },
}
