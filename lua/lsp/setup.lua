-- 加载lsp后执行的回调
local lspconfig = require("lspconfig")

-- local on_attach = function(_, bufnr)
--   local map = function(mode, lhs, rhs)
--     vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
--   end
--   -- set local keymap for the lsp
--   map("n", "gd", vim.lsp.buf.definition)
--   map("n", "gr", vim.lsp.buf.references)
--   map("n", "K", vim.lsp.buf.hover)
--   map("n", "<leader>rn", vim.lsp.buf.rename)
-- end

-- ensure default capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- add additional capabilities for all the clients
-- vim.lsp.config('*', {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })
local servers = require("lsp.servers")
for _, server in ipairs(servers) do
  local opts = { capabilities = capabilities }
  if server == "html" then
    opts.filetypes = { "html", "templ", "htmldjango" }
    opts.get_language_id = function(_, filetype)
      return filetype == "htmldjango" and "html" or filetype
    end
  end
  lspconfig[server].setup(opts)
end

vim.diagnostic.config({
  virtual_text = true,  -- 在行尾显示错误
  signs = true,         -- 左侧 gutter 显示图标
  underline = true,
  update_in_insert = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- 只对 LSP buffer 生效
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
    vim.keymap.set("n", "gr", vim.lsp.buf.references)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  end,
})
