return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",

  opts = {
    ensure_installed = { "lua", "python", "markdown", "php", "go", "javascript", "vue" },

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
