return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false, -- 启动时就加载
  opts = {
    flavour = "macchiato",  -- 可选: latte, frappe, macchiato, mocha
    transparent_background = false,
    term_colors = true,
    styles = {
      comments = { "italic" },
      functions = { },
    },
    integrations = { -- 融合其他插件
      telescope = true,
      treesitter = true,
      cmp = true,
      lsp_trouble = true,
      lsp_saga = true,
      gitsigns = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd("colorscheme catppuccin")
  end,
}
