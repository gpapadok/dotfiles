return {
  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
      local filetype = vim.bo[vim.uri_to_bufnr(result.uri)].filetype

      -- Disable ts diagnostics for vue buffers
      if filetype == 'vue' then
        result.diagnostics = vim.tbl_filter(function(d)
          return d.source ~= 'ts-plugin'
        end, result.diagnostics)
      end

      -- Disable checkJs diagnostics for plain JS buffers
      if filetype == 'javascript' or filetype == 'javascriptreact' then
        result.diagnostics = {}
      end

      vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, config)
    end,
  },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fn.stdpath('data')
              .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
        },
      },
    },
  },
}
