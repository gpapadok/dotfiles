return {
  "mason.nvim",
  dependencies = {
    { "mason-org/mason-lspconfig.nvim", config = function() end },
  },
  config = function()
    require("mason").setup({

    })
  end,
}
