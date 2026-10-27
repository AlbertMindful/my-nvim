-- Markdown 编辑体验 (仅终端 nvim; VS Code 侧由 settings.json / core/vscode.lua 处理)
if vim.g.vscode then
  return
end

-- 软换行 (按词换行, 而非按列)
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true

-- 预览切换: 行内渲染 开/关 (render-markdown)
vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", { buffer = 0, desc = "切换 Markdown 渲染" })

-- 切换任务复选框 [ ] <-> [x]
vim.keymap.set("n", "<leader>mt", function()
  local line = vim.fn.getline(".")
  local toggled = line:gsub("%[%s%]", "[x]", 1)
  if toggled == line then
    toggled = line:gsub("%[x%]", "[ ]", 1)
  end
  if toggled ~= line then
    vim.fn.setline(".", toggled)
  end
end, { buffer = 0, desc = "切换任务复选框" })
