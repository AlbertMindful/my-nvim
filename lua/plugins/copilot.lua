return {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    vim.g.copilot_enabled = false
  end,
  keys = {
    {
      "<leader>cp",
      function()
        local enabled = vim.fn["copilot#Enabled"]() == 1
        vim.cmd(enabled and "Copilot disable" or "Copilot enable")
        vim.notify("Copilot 补全已" .. (enabled and "关闭" or "开启"))
      end,
      mode = "n",
      desc = "切换 Copilot 补全",
    },
  },
}
