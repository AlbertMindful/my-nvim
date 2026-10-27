-- 只保留 Markdown 数学公式预览，不接管图片文件或图片链接。
return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    image = {
      enabled = true,
      formats = {},
      -- WezTerm 下公式使用光标处浮窗。
      doc = {
        enabled = true,
        inline = false,
        float = true,
        max_width = 70,
        max_height = 24,
        conceal = false,
      },
      wo = { foldenable = false, cursorline = false },
      math = { enabled = true },
      convert = { notify = true },
    },
    styles = {
      snacks_image = { border = "rounded", backdrop = false },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    -- 新建笔记也立即获得预览，不必先打开一个已有文件。
    require("snacks.image").setup()
    -- 公式沿用主题正文颜色，避免启动时缓存默认配色的深色文字。
    require("snacks.util").set_hl({ Math = "Normal" }, { prefix = "SnacksImage" })
    -- aligned / cases / matrix 是数学子环境，需要外层数学模式。
    local doc = require("snacks.image.doc")
    local extract = doc._img
    doc._img = function(ctx)
      local kind = ctx.meta["image.type"]
      if kind == nil then
        kind = (ctx.meta["image.ext"] or ""):match("^(%w+)%.")
      end
      if kind ~= "math" then
        return nil
      end
      return extract(ctx)
    end
    local transform = doc.transforms.latex
    local subenvs = {
      aligned = true, alignedat = true, gathered = true, split = true,
      cases = true, matrix = true, pmatrix = true, bmatrix = true,
      Bmatrix = true, vmatrix = true, Vmatrix = true, smallmatrix = true,
      array = true,
    }
    doc.transforms.latex = function(img, ctx)
      if img.ext == "math.tex" and img.content then
        local content = vim.trim(img.content)
          :gsub("^%$+`?", ""):gsub("`?%$+$", "")
        content = vim.trim(content)
        local env = content:match("^\\begin{([^}]+)}")
        if subenvs[env] then
          img.content = "\\displaystyle " .. content
        end
      end
      return transform(img, ctx)
    end
  end,
}
