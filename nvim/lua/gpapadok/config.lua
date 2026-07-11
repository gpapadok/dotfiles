return {
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
  commands = {
    'au BufWrite * lua vim.fn.trim_trailing_whitespace()',
  },
}
