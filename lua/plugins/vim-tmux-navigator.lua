-- 保留原有习惯: Ctrl+h/j/k/l 在 vim 分屏 / tmux 窗格间无缝移动
-- (从旧 packer 迁移到 lazy, 行为不变)
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
}
