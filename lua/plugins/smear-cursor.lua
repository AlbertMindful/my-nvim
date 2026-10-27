-- 光标平滑动画: 类似 VS Code 的 cursorSmoothCaretAnimation / smear 效果
-- 注意: 在 vscode-neovim 下不加载(见 plugins/vscode.lua), 因为光标由 VS Code 渲染。
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- 在插入模式下也做平滑动画(输入时光标滑动), 对齐 VS Code 默认体验
    smear_insert_mode = true,

    -- 跨 buffer / 相邻行之间也做 smear 过渡
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,

    -- 窗口滚动时在 buffer 空间绘制 smear, 观感更连贯
    scroll_buffer_space = true,

    -- smear 尾部距目标小于该字符数时停止动画(默认 0.1)
    distance_stop_animating = 0.1,

    -- 旧式符号字体兼容(一般保持 false)
    legacy_computing_symbols_support = false,
  },
}
