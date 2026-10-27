-- vscode-neovim 下加载的精简插件列表
-- 原则: 只保留纯编辑类插件; LSP/补全/文件树/状态栏/语法高亮/缩进线/git 装饰
-- 等全部交给 VS Code 原生能力(见 core/vscode.lua 的键位映射)。
-- 自动括号改由 VS Code 原生 autoClosingBrackets 处理, 故不再加载 nvim-autopairs。
return {
  -- gcc/gbc 注释
  { "numToStr/Comment.nvim" },

  -- 环绕编辑 ys/cs/ds/S (复用原配置)
  require("plugins.surround"),

  -- leader 提示 ,f/,g (复用原配置)
  require("plugins.which-key"),
}
