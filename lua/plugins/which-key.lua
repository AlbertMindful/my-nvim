-- 快捷键提示: 按 leader(,) 后停留片刻弹出可发现菜单
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "查找 / 搜索", icon = " " },
      { "<leader>g", group = "git", icon = " " },
      { "<leader>s", group = "遮蔽 / 搜索", icon = " " },
    },
  },
}
