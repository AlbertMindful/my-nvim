-- 现代 REPL 体验: 浮动终端 (toggleterm) + 代码发送
-- ,tp Python REPL (ipython)  /  ,ts SML REPL (rlwrap sml)  /  ,tx 发送代码
return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        size = 15,
        direction = "float",
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        close_on_exit = false,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = { border = "Normal", background = "Normal" },
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local python_repl = Terminal:new({ cmd = "ipython", direction = "float", hidden = true })
      local sml_repl = Terminal:new({ cmd = "rlwrap sml", direction = "float", hidden = true })

      function _G._toggle_python_repl()
        python_repl:toggle()
      end
      function _G._toggle_sml_repl()
        sml_repl:toggle()
      end

      local map = vim.keymap.set
      map("n", "<leader>tp", "<cmd>lua _toggle_python_repl()<cr>", { desc = "Python REPL (ipython)" })
      map("n", "<leader>ts", "<cmd>lua _toggle_sml_repl()<cr>", { desc = "SML REPL (rlwrap sml)" })
      map("n", "<leader>tx", "<cmd>ToggleTermSendCurrentLine<cr>", { desc = "发送当前行到终端" })
      map("v", "<leader>tx", "<cmd>ToggleTermSendVisualLines<cr>", { desc = "发送选区到终端" })
    end,
  },
}
