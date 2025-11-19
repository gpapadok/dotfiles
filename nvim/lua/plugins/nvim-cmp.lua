return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
  },
  config = function()
    local cmp = require "cmp"

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })

    -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- local servers = { 'intelephense', 'lua_ls' }
    -- for _, server in pairs(servers) do
    --   require('lspconfig')[server].setup {
    --     capabilities = capabilities,
    --   }
    -- end

    -- require('lspconfig')['intelephense'].setup {
    --   capabilities = capabilities,
    -- }
    -- require('lspconfig').lua_ls.setup {
    --   capabilities = capabilities,
    -- }
  end,
  -- snippet = {
  --   expand = function(args)
  --     vim.fn["vsnip#anonymous"](args.body)
  --   end,
  -- },



	 -- config = function()
	 --   local cmp = require("cmp")
	 --   -- local luasnip = require("luasnip")
	 --
	 --   cmp.setup({
	 --     snippet = {
	 --       expand = function(args)
	 --         luasnip.lsp_expand(args.body)
	 --       end,
	 --     },
	 --   })
	 -- end,
  -- opts = {
  --   completion = {
  --     completeopt = "menu,menuone,preview,noselect",
  --   },
  --   -- snippet = {
  --   --   expand = function(args)
  --   --
  --   --   end,
  --   -- },
  -- }
}
