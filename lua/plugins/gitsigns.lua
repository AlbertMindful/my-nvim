-- git 行内标记 / 修改块跳转 / blame
-- 键位(增量): ]c [c 跳转修改块, ,gs 暂存 ,gr 撤销 ,gp 预览 ,gb blame ,gd diff
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▎" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
  },
  config = function(_, opts)
    local gs = require("gitsigns")
    gs.setup(opts)

    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "下一处修改" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "上一处修改" })

    vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "暂存当前块" })
    vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "撤销当前块" })
    vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "预览当前块" })
    vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "行 blame" })
    vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "当前文件 diff" })
  end,
}
