-- SML (Standard ML) 编辑体验
-- LSP 由 millet 提供 (见 lua/lsp/servers.lua), gd/gr/K/,rn/,ca 等键位自动生效。
if not vim.g.vscode then
  -- 用 SML/NJ 运行当前文件 (底部打开交互式 REPL, rlwrap 提供行编辑/历史)
  vim.keymap.set("n", "<leader>rr", function()
    vim.cmd("botright terminal rlwrap sml " .. vim.fn.shellescape(vim.fn.expand("%:p")))
  end, { buffer = 0, desc = "SML/NJ 运行当前文件" })
end
