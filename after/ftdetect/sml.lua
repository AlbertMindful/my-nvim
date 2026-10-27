-- 补充 SML 文件类型检测 (nvim 默认只识别 .sml)
-- .sig = 签名 (signature), .fun = 函子 (functor)
vim.filetype.add({
  extension = {
    sig = "sml",
    fun = "sml",
  },
})
