return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "|" },
      change = { text = "|" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "|" },
    },
    signs_staged = {
      add = { text = "|" },
      change = { text = "|" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "|" },
    },
    signs_staged_enable = true,
    singcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_untracked = false,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local keys = {
        {
          'n',
          ']c',
          function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end,
          { desc = 'Gitsigns - next hunk' },
        },
        {
          'n',
          '[c',
          function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end,
          { desc = 'Gitsigns - prev hunk' },
        },
      }

      vim.fn.keymaps_set(keys, { buffer = bufnr })
    end,
  },
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame<cr>', desc = 'Gitsigns - blame', mode = 'n' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Gitsigns - stage hunk', mode = 'n' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Gitsigns - reset hunk', mode = 'n' },
    { '<leader>gs', function() return ':Gitsigns stage_hunk<cr>' end, desc = 'Gitsigns - stage hunk', mode = 'v', expr = true },
    { '<leader>gr', function() return ':Gitsigns reset_hunk<cr>' end, desc = 'Gitsigns - reset hunk', mode = 'v', expr = true },
    { '<leader>gS', '<cmd>Gitsigns stage_buffer<cr>', desc = 'Gitsigns - stage buffer', mode = 'n' },
    { '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Gitsigns - reset buffer', mode = 'n' },
    { '<leader>gp', '<cmd>Gitsigns preview_buffer<cr>', desc = 'Gitsigns - preview buffer', mode = 'n' },
    { '<leader>gi', '<cmd>Gitsigns preview_buffer_inline<cr>', desc = 'Gitsigns - preview buffer inline', mode = 'n' },
    { '<leader>gB', '<cmd>Gitsigns blame_line --full<cr>', desc = 'Gitsigns - blame line', mode = 'n' },
    { '<leader>gd', '<cmd>Gitsigns diffthis<cr>', desc = 'Gitsigns - diff this', mode = 'n' },
    { '<leader>gD', '<cmd>Gitsigns diffthis ~<cr>', desc = 'Gitsigns - diff this ~', mode = 'n' },
    { '<leader>gq', '<cmd>Gitsigns setqflist<cr>', desc = 'Gitsigns - setqflist', mode = 'n' },
    { '<leader>gQ', '<cmd>Gitsigns setqflist all<cr>', desc = 'Gitsigns - setqflist all', mode = 'n' },
    { '<leader>gt', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Gitsigns - toggle current line blame', mode = 'n' },
    { '<leader>gT', '<cmd>Gitsigns toggle_word_diff<cr>', desc = 'Gitsigns - toggle word diff', mode = 'n' },
  },
}
