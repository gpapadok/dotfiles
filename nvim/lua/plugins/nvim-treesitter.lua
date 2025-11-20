return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",

  config = function(_, opts)
    require'nvim-treesitter.configs'.setup(opts)
  end,

  opts = {
    ensure_installed = vim.list_extend(
      { "lua", "python", "markdown" },
      vim.fn.array_if(os.getenv("LWDEV") == "True", { "php", "go" })
    ),

    sync_install = false,
    auto_install = false,

    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },
  },
}
