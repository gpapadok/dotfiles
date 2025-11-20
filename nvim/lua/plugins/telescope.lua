return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files', mode = 'n' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Telescope live grep', mode = 'n' },
    { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Telescope buffers', mode = 'n' },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Telescope help tags', mode = 'n' },

    { "<leader>k", "<cmd>Telescope lsp_references<cr>", desc = "Telescope - show LSP references", mode = "n" },
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Telescope - show LSP definitions", mode = "n"  },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Telescope - show LSP implementations", mode = "n" },
    { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Telescope - show LSP type definitions", mode = "n" },
    { "<leader>D", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Telescope - show buffer diagnostics", mode = "n" },
  },
}
