local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.smartindent = true

opt.termguicolors = true
opt.cursorline = true
opt.showmode = false

-- 设置持久化撤销
opt.undofile = true
-- 设置撤销文件目录
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if not vim.fn.isdirectory(undo_dir) then
  vim.fn.mkdir(undo_dir, "p")
end

vim.opt.undodir = undo_dir

-- 启用代码块折叠 (vscode-neovim 由 VS Code 接管折叠, 此处跳过)
-- Code folding
if not vim.g.vscode then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

  -- 默认不自动把代码全部折起来
  vim.opt.foldlevel = 99
  vim.opt.foldenable = true
end
