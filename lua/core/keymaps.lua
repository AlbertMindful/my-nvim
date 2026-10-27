vim.g.mapleader = ","

local keymap = vim.keymap

-- 文件树 (保留)
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "切换文件树" })

-- 窗口导航 (保留原有 ,hjkl)
keymap.set("n", "<leader>h", "<C-w>h", { desc = "窗口 ←" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "窗口 ↓" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "窗口 ↑" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "窗口 →" })

-- 诊断浮窗 (保留)
keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, {
    focus = false,
    border = "rounded",
    source = "if_many",
  })
end, { desc = "诊断详情浮窗" })

-- jj -> Esc (保留; vscode-neovim 下改由 compositeKeys 处理, 避免重复/延迟)
if not vim.g.vscode then
  keymap.set("i", "jj", "<Esc>", { noremap = true })
  keymap.set("i", "jk", "j", { noremap = true, desc = "输入 j" })

  -- 临时遮蔽：只改变显示，extmark 不会修改 buffer 或磁盘文件
  local redact = require("core.redact")
  keymap.set("x", "<leader>s", redact.add_visual, { desc = "遮蔽选中文字" })
  keymap.set("n", "<leader>su", redact.remove_at_cursor, { desc = "解除光标处遮蔽" })
  keymap.set("n", "<leader>sc", redact.clear, { desc = "清除当前 buffer 全部遮蔽" })
end
