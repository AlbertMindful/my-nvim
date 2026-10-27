-- 滚动时置顶显示当前函数 / 类的上下文
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    mode = "cursor",
    max_lines = 3,
  },
}
