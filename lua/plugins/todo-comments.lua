-- TODO/FIXME/HACK 等注释高亮与跳转 (]t [t 跳转, ,st 搜索)
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = { signs = true },
  config = function(_, opts)
    require("todo-comments").setup(opts)
    vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "搜索 TODO/FIXME" })
  end,
}
