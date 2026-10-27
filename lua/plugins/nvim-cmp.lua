return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",  -- 插入模式延迟加载
  dependencies = {
    "L3MON4D3/LuaSnip",            -- snippet 引擎
    "saadparwaiz1/cmp_luasnip",    -- snippet 补全源
    "hrsh7th/cmp-buffer",          -- buffer 词补全
    "hrsh7th/cmp-path",            -- 文件路径补全
    "rafamadriz/friendly-snippets", -- 常用代码片段
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load() -- 加载 friendly-snippets
    cmp.setup({
      experimental = {
        ghost_text = true,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end
}
