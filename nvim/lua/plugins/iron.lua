return {
  "hkupty/iron.nvim",

  config = function(plugins, opts)
    require("iron.core").setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { "python3" },
          },
        },
        repl_open_cmd = require("iron.view").right(60),
      },

      highlight = {
        italic = true,
      },

      ignore_blank_lines = true,

      keymaps = {
        send_motion = "<leader>rc",
        visual_send = "<leader>rc",
        send_file = "<leader>rf",
        send_line = "<leader>rl",
        send_mark = "<leader>rm",
        mark_motion = "<leader>rmc",
        mark_visual = "<leader>rmc",
        remove_mark = "<leader>rmd",
        cr = "<leader>r<cr>",
        interrupt = "<leader>r<space>",
        exit = "<leader>rq",
        clear = "<leader>rx",
      },
    })
  end,

  keys = {
    { '<leader>rs', '<cmd>IronRepl<cr>', desc = 'Iron Repl', mode = 'n' },
    { '<leader>rr', '<cmd>IronRestart<cr>', desc = 'Iron Restart', mode = 'n' },
    { '<leader>rF', '<cmd>IronRestart<cr>', desc = 'Iron Focus', mode = 'n' },
    { '<leader>rh', '<cmd>IronRestart<cr>', desc = 'Iron Hide', mode = 'n' },
  },
}
