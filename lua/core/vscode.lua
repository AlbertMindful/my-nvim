-- vscode-neovim 专用键位: 把 nvim 的习惯键位映射到 VS Code 命令。
-- 仅在 vim.g.vscode 时由 init.lua require; gd/gD/K/== 等已由扩展默认绑定。
local ok, vscode = pcall(require, "vscode")
if not ok then
  return -- 无 vscode 模块(如 headless 测试), 静默退出
end

local map = vim.keymap.set

local function run(name, opts)
  return function()
    vscode.action(name, opts)
  end
end

-- 文件树 → 侧边栏 (资源管理器)
map("n", "<leader>e", run("workbench.action.toggleSidebarVisibility"), { desc = "切换文件树" })

-- 窗口导航: ,hjkl 保留原映射(<C-w>hjkl, 扩展已处理); 这里补 C-hjkl (vim-tmux-navigator 习惯)
map("n", "<C-h>", run("workbench.action.focusLeftGroup"), { desc = "焦点 ←" })
map("n", "<C-j>", run("workbench.action.focusBelowGroup"), { desc = "焦点 ↓" })
map("n", "<C-k>", run("workbench.action.focusAboveGroup"), { desc = "焦点 ↑" })
map("n", "<C-l>", run("workbench.action.focusRightGroup"), { desc = "焦点 →" })

-- 诊断
map("n", "<leader>d", run("workbench.actions.view.problems"), { desc = "诊断面板" })
map("n", "[d", run("editor.action.marker.prev"), { desc = "上一个诊断" })
map("n", "]d", run("editor.action.marker.next"), { desc = "下一个诊断" })

-- LSP (gd/gD/K/== 由扩展默认绑定; 补充 gr/,rn/,ca)
map("n", "gr", run("editor.action.referenceSearch.trigger"), { desc = "引用" })
map("n", "gD", run("editor.action.revealDeclaration"), { desc = "声明" })
map("n", "<leader>rn", run("editor.action.rename"), { desc = "重命名" })
map("n", "<leader>ca", run("editor.action.quickFix"), { desc = "代码操作" })

-- Copilot 行内补全（与独立 Neovim 使用相同快捷键）
map("n", "<leader>cp", run("github.copilot.chat.completions.toggle"), { desc = "切换 Copilot 补全" })

-- 查找 (telescope → VS Code 快速打开/搜索)
map("n", "<leader>ff", run("workbench.action.quickOpen"), { desc = "查找文件" })
map("n", "<leader>fg", run("workbench.action.findInFiles"), { desc = "全文搜索" })
map("n", "<leader>fb", run("workbench.action.showAllEditors"), { desc = "查找 buffer" })
map("n", "<leader>fr", run("workbench.action.openRecent"), { desc = "最近文件" })
map("n", "<leader>fc", function()
  vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end, { desc = "搜索光标词" })

-- git (gitsigns → VS Code git 命令)
map("n", "]c", run("workbench.action.editor.nextChange"), { desc = "下一处修改" })
map("n", "[c", run("workbench.action.editor.previousChange"), { desc = "上一处修改" })
map("n", "<leader>gs", run("git.stage"), { desc = "暂存当前文件" })
map("n", "<leader>gr", run("git.revertSelectedRanges"), { desc = "撤销当前块" })
map("n", "<leader>gp", run("git.openChange"), { desc = "预览 diff" })
map("n", "<leader>gb", run("git.blame"), { desc = "行 blame" })
map("n", "<leader>gd", run("git.openChange"), { desc = "当前文件 diff" })

-- TODO 搜索 (todo-comments → VS Code 搜索)
map("n", "<leader>st", function()
  vscode.action("workbench.action.findInFiles", {
    args = { query = "TODO|FIXME|HACK|XXX|NOTE", isRegex = true },
  })
end, { desc = "搜索 TODO/FIXME" })

-- treesitter 增量选择 (gnn/grn/grc/grm → VS Code smart select)
map("n", "gnn", run("editor.action.smartSelect.expand"), { desc = "初始化选择" })
map("n", "grn", run("editor.action.smartSelect.grow"), { desc = "扩大选择" })
map("n", "grc", run("editor.action.smartSelect.grow"), { desc = "扩大到作用域" })
map("n", "grm", run("editor.action.smartSelect.shrink"), { desc = "缩小选择" })

-- Markdown
map("n", "<leader>mp", run("markdown.showPreviewToSide"), { desc = "Markdown 预览" })
map("n", "<leader>mo", run("workbench.action.gotoSymbol"), { desc = "Markdown 大纲" })

-- REPL / 终端 (Python: ipython; SML: rlwrap sml 任务)
map("n", "<leader>tp", run("python.startREPL"), { desc = "Python REPL" })
map("n", "<leader>ts", function()
  vscode.action("workbench.action.tasks.runTask", { args = "SML REPL" })
end, { desc = "SML REPL" })
map("n", "<leader>tx", run("workbench.action.terminal.runSelectedText"), { desc = "发送当前行到终端" })
map("v", "<leader>tx", run("workbench.action.terminal.runSelectedText"), { desc = "发送选区到终端" })
