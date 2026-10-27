-- 语法高亮 / 折叠 / 缩进 / 增量选择
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Django 模板中的 HTML 标签使用已安装的 HTML parser。
    vim.treesitter.language.register("html", "htmldjango")
    require("nvim-treesitter.configs").setup({
      -- 注: 不含 latex —— LaTeX 高亮交由 vimtex 负责, 避免 treesitter-latex 冲突
      ensure_installed = {
        "lua", "vim", "vimdoc", "query", "printf",
        "python", "bash", "c", "cpp",
        "json", "yaml", "html", "css", "markdown", "markdown_inline",
        "typescript", "javascript", "regex", "comment",
      },
      -- 关闭 auto_install: 避免打开 .tex 时自动拉取 latex parser 报错(LaTeX 由 vimtex 负责)
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    })
  end,
}
