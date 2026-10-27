-- 在你的插件列表中添加
return {
  "lervag/vimtex",
  -- 锁定到兼容 nvim 0.11 的版本(最新版要求 nvim 0.12.4+)
  commit = "24e229914182ff301496a3e2c4214b28c4928d3f",
  lazy = false, -- Vimtex 建议设置为非懒加载
  init = function()
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_view_method = 'skim'
  end,
}
