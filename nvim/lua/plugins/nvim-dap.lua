return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    local signs = {
      { name = 'DapBreakpoint', opts = { text = '🔴' } },
      { name = 'DapStopped', opts = { text = '⮕', texthl = '#f5c211' } },
    }

    -- A '#rrggbb' texthl is turned into a highlight group named after the sign;
    -- anything else is passed through as an existing group name.
    for _, sign in pairs(signs) do
      if sign.opts.texthl and sign.opts.texthl:sub(1, 1) == '#' then
        local group = sign.name .. 'Hl'
        vim.api.nvim_set_hl(0, group, { fg = sign.opts.texthl })
        sign.opts.texthl = group
      end
      vim.fn.sign_define(sign.name, sign.opts)
    end

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/workspace/vscode-php-debug/out/phpDebug.js" }
    }
    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        pathMappings = { ["/app"] = "${workspaceFolder}" }
      },
    }
  end,
  keys = {
    { "<leader>dc", function() require("dap").continue() end, desc = "Start a new session (Dap)" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step over the current line (Dap)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step into the current expression (Dap)" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step out of the current scope (Dap)" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint on current line (Dap)" },
    { "<leader>dB", function() require("dap").set_breakpoint() end, desc = "Set breakpoint on current line (Dap)" },
    {
      "<leader>dp",
      function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
      desc = "Set breakpoint on current line (Dap)",
    },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL (Dap)" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Restart the current frame (?) (Dap)" },
  },
}
