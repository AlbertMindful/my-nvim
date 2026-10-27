local notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" then
    -- 过滤 nvim-lspconfig deprecation 及其 traceback
    if msg:match("nvim%-lspconfig")
       or msg:match("lspconfig%.lua")
       or msg:match("^stack traceback")
    then
      return
    end
  end
  notify(msg, level, opts)
end
