-- clone lazy if lazy doesn't exists
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- loads config
-- 顺序很重要: 必须先 lazy.setup 加载插件, 之后 lsp 才能 require(mason/lspconfig 等)
require("core")

if vim.g.vscode then
  -- 运行于 vscode-neovim: 只加载纯编辑类插件; LSP/补全/UI 交给 VS Code
  require("lazy").setup(require("plugins.vscode"))
  require("core.vscode")
else
  require("lazy").setup(require("plugins"))
  require("lsp")
end
