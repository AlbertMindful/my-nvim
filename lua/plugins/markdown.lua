-- 阅读与编辑共用同一份 Markdown，光标所在行保持可编辑。
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- 公式交给 Snacks 使用真正的 LaTeX 渲染，避免重复显示。
      latex = { enabled = false },
      heading = { sign = false, width = "block", right_pad = 1 },
      bullet = { icons = { "•", "◦" } },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      local function colors()
        local p = require("catppuccin.palettes").get_palette("macchiato")
        for i = 1, 6 do
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = p.mauve, bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = p.base })
        end
        vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = p.lavender })
        vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = p.blue, underline = true })
      end
      colors()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("quiet_markdown_colors", { clear = true }),
        callback = colors,
      })
    end,
  },
}
