return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "CmdLineEnter" },
  ft = { "go", "gomod" },
  build = function()
    if vim.fn.executable("go") == 1 then
      require("go.install").update_all_sync()
    end
  end
}
