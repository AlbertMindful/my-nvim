local servers = {
  "lua_ls",
  "clangd",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "html",
  "cssls",
  "texlab",
  "marksman",  -- Markdown (链接跳转/引用/重命名/补全)
  -- 原有 mason 里已安装、补登记
  "ts_ls",   -- TypeScript
  "cmake",   -- CMake
  "awk_ls",  -- AWK
  "millet",  -- SML (Standard ML)
}
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

return servers
