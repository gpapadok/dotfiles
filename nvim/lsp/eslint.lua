return {
  handlers = {
    ['textDocument/diagnostic'] = function(err, result, ctx, config)
      local disabledRules = {
        ['no-tabs'] = true,
        ['no-mixed-spaces-and-tabs'] = true,
        ['vue/order-in-components'] = true,
        ['curly'] = true,
      }

      if result and result.items then
        result.items = vim.tbl_filter(function(d)
          return not disabledRules[d.code]
        end, result.items)
      end

      vim.lsp.handlers['textDocument/diagnostic'](err, result, ctx, config)
    end,
  },
}
