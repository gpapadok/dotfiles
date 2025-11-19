return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    local signs = {
      { name = 'DapBreakpoint', opts = { text = '🔴' } },
      { name = 'DapStopped', opts = { text = '⮕', texthl = 'f00' } }, -- color doesn't work
    }

    for _, sign in pairs(signs) do
      vim.fn.sign_define(sign.name, sign.opts)
    end

    -- vim.fn.sign_define('DapBreakpoint', { text = '🔴' })

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

    local keys = {
      { "n", "<leader>dc", function() dap.continue() end, { desc = "Start a new session (Dap)" } },
      { "n", "<leader>do", function() dap.step_over() end, { desc = "Step over the current line (Dap)" } },
      { "n", "<leader>di", function() dap.step_into() end, { desc = "Step into the current expression (Dap)" } },
      { "n", "<leader>dO", function() dap.step_out() end, { desc = "Step out of the current scope (Dap)" } },
      { "n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint on current line (Dap)" } },
      { "n", "<leader>dB", function() dap.set_breakpoint() end, { desc = "Set breakpoint on current line (Dap)" } },
      {
        "n", "<leader>dp", function()
          dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end, { desc = "Set breakpoint on current line (Dap)" },
      },
      { "n", "<leader>dr", function() dap.repl.open() end, { desc = "Open REPL (Dap)" } },
      { "n", "<leader>dl", function() dap.run_last() end, { desc = "Restart the current frame (?) (Dap)" } },
    }

    vim.fn.keymaps_set(keys, {})
  end,
}
