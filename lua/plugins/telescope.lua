-- 模糊查找: 文件/文本/buffer/帮助
-- 键位与原配置完全一致: ,ff ,fg ,fb ,fh (新增 ,fr 最近文件 / ,fc 光标词)
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "全文搜索" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "查找 buffer" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "查找帮助" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "最近文件" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "搜索光标词" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
        file_ignore_patterns = { "%.git/", "node_modules/", "%.DS_Store" },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
