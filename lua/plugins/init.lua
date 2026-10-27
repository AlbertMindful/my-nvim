return {
  -- 基础
  { "neovim/nvim-lspconfig" },             -- LSP 配置
  { "williamboman/mason.nvim" },           -- LSP 服务器管理
  { "williamboman/mason-lspconfig.nvim" },
  { "L3MON4D3/LuaSnip" },                  -- snippet 引擎
  { "hrsh7th/cmp-nvim-lsp" },              -- LSP 补全源(启动时 lsp/setup 需 require, 故 eager)
  { "numToStr/Comment.nvim" },             -- gcc/gbc 注释
  require("plugins.copilot"),              -- AI code completion
  -- 功能插件
  require("plugins.autopairs"),            -- 自动括号
  require("plugins.autotag"),              -- HTML 标签自动闭合/同步重命名
  require("plugins.nvim-tree"),            -- 目录树
  require("plugins.nvim-cmp"),             -- 自动补全
  require("plugins.colorscheme"),          -- 配色
  require("plugins.lualine"),              -- 状态栏
  require("plugins.vimtex"),               -- LaTeX
  require("plugins.treesitter"),           -- 语法高亮/折叠
  require("plugins.telescope"),            -- 模糊查找
  require("plugins.gitsigns"),             -- git 行内标记
  require("plugins.which-key"),            -- 快捷键提示
  require("plugins.surround"),             -- 环绕编辑
  require("plugins.indent-blankline"),     -- 缩进参考线
  require("plugins.treesitter-context"),   -- 滚动上下文
  require("plugins.todo-comments"),        -- TODO 高亮
  require("plugins.vim-tmux-navigator"),   -- C-hjkl 窗口/tmux 移动
  require("plugins.images"),               -- Markdown 数学公式预览
  require("plugins.markdown"),             -- Markdown 行内渲染
  require("plugins.terminal"),             -- 浮动终端 / REPL
  require("plugins.smear-cursor"),         -- 光标平滑动画(类 VS Code)
}
