local M = {}

-- Anchor extmarks only track ranges; render extmarks provide the conceal effect.
-- Keeping them separate lets the group under the cursor be revealed temporarily.
local anchor_ns = vim.api.nvim_create_namespace("visual_redact_anchors")
local render_ns = vim.api.nvim_create_namespace("visual_redact")
local states = {}

local function state_for(bufnr)
  local state = states[bufnr]
  if not state then
    state = { next_group = 1, groups = {}, window_options = {} }
    states[bufnr] = state
  end
  return state
end

local function has_groups(state)
  return next(state.groups) ~= nil
end

local function enable_conceal(bufnr)
  local state = state_for(bufnr)
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    if not state.window_options[winid] then
      state.window_options[winid] = {
        conceallevel = vim.wo[winid].conceallevel,
        concealcursor = vim.wo[winid].concealcursor,
      }
    end

    if vim.wo[winid].conceallevel ~= 2 then
      vim.wo[winid].conceallevel = 2
    end
    local concealcursor = vim.wo[winid].concealcursor
    for _, mode in ipairs({ "n", "v", "i", "c" }) do
      if not concealcursor:find(mode, 1, true) then
        concealcursor = concealcursor .. mode
      end
    end
    if vim.wo[winid].concealcursor ~= concealcursor then
      vim.wo[winid].concealcursor = concealcursor
    end
  end
end

local function restore_conceal(bufnr, state)
  for winid, options in pairs(state.window_options) do
    if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr then
      vim.wo[winid].conceallevel = options.conceallevel
      vim.wo[winid].concealcursor = options.concealcursor
    end
  end
  state.window_options = {}
end

local function anchor(bufnr, mark_id)
  local mark = vim.api.nvim_buf_get_extmark_by_id(bufnr, anchor_ns, mark_id, { details = true })
  if #mark == 0 or mark[3].invalid then
    return nil
  end
  return mark
end

local function group_at(bufnr, state, row, col)
  for group_id, mark_ids in pairs(state.groups) do
    for _, mark_id in ipairs(mark_ids) do
      local mark = anchor(bufnr, mark_id)
      if mark then
        local start_row, start_col, details = mark[1], mark[2], mark[3]
        if row == start_row and col >= start_col and col < details.end_col then
          return group_id
        end
      end
    end
  end
end

local function refresh(bufnr, force)
  local state = states[bufnr]
  if not state or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  enable_conceal(bufnr)

  local active_group
  if vim.api.nvim_get_current_buf() == bufnr then
    local cursor = vim.api.nvim_win_get_cursor(0)
    active_group = group_at(bufnr, state, cursor[1] - 1, cursor[2])
  end

  if not force and state.active_group == active_group then
    return
  end
  state.active_group = active_group

  vim.api.nvim_buf_clear_namespace(bufnr, render_ns, 0, -1)
  for group_id, mark_ids in pairs(state.groups) do
    if group_id ~= active_group then
      for _, mark_id in ipairs(mark_ids) do
        local mark = anchor(bufnr, mark_id)
        if mark then
          vim.api.nvim_buf_set_extmark(bufnr, render_ns, mark[1], mark[2], {
            end_row = mark[3].end_row,
            end_col = mark[3].end_col,
            conceal = "█",
            hl_group = "VisualRedactMask",
            priority = 1000,
            invalidate = true,
            undo_restore = true,
          })
        end
      end
    end
  end
end

local function end_col_exclusive(line, one_based_col)
  if one_based_col > #line then
    return #line
  end

  local zero_based_col = math.max(one_based_col - 1, 0)
  local char = vim.fn.strcharpart(line:sub(zero_based_col + 1), 0, 1)
  return zero_based_col + #char
end

function M.add_visual()
  local bufnr = vim.api.nvim_get_current_buf()
  local regions = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), {
    type = vim.fn.mode(),
    eol = true,
  })
  if vim.tbl_isempty(regions) then
    vim.notify("没有可遮蔽的选区", vim.log.levels.WARN)
    return
  end

  local state = state_for(bufnr)
  local group_id = state.next_group
  state.next_group = group_id + 1
  state.groups[group_id] = {}

  for _, region in ipairs(regions) do
    local start_pos, end_pos = region[1], region[2]
    local row = start_pos[2] - 1
    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
    local start_col = math.max(start_pos[3] - 1, 0)
    local end_col = end_col_exclusive(line, end_pos[3])

    if start_col < end_col then
      local mark_id = vim.api.nvim_buf_set_extmark(bufnr, anchor_ns, row, start_col, {
        end_row = row,
        end_col = end_col,
        invalidate = true,
        undo_restore = true,
      })
      table.insert(state.groups[group_id], mark_id)
    end
  end

  if vim.tbl_isempty(state.groups[group_id]) then
    state.groups[group_id] = nil
    vim.notify("选区没有可遮蔽的文字", vim.log.levels.WARN)
    return
  end

  refresh(bufnr, true)
end

local function delete_group(bufnr, state, group_id)
  for _, mark_id in ipairs(state.groups[group_id] or {}) do
    pcall(vim.api.nvim_buf_del_extmark, bufnr, anchor_ns, mark_id)
  end
  state.groups[group_id] = nil

  if has_groups(state) then
    refresh(bufnr, true)
  else
    vim.api.nvim_buf_clear_namespace(bufnr, render_ns, 0, -1)
    restore_conceal(bufnr, state)
    states[bufnr] = nil
  end
end

function M.remove_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = states[bufnr]
  if not state then
    vim.notify("光标处没有遮蔽", vim.log.levels.INFO)
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local group_id = group_at(bufnr, state, cursor[1] - 1, cursor[2])
  if group_id then
    delete_group(bufnr, state, group_id)
  else
    vim.notify("光标处没有遮蔽", vim.log.levels.INFO)
  end
end

function M.clear()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = states[bufnr]
  if not state then
    vim.notify("当前 buffer 没有遮蔽", vim.log.levels.INFO)
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, anchor_ns, 0, -1)
  vim.api.nvim_buf_clear_namespace(bufnr, render_ns, 0, -1)
  restore_conceal(bufnr, state)
  states[bufnr] = nil
end

local function define_highlight()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local conceal = vim.api.nvim_get_hl(0, { name = "Conceal", link = false })
  local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
  local mask_color = conceal.fg or visual.bg or normal.fg or normal.bg or 0x808080
  vim.api.nvim_set_hl(0, "VisualRedactMask", {
    fg = mask_color,
    bg = mask_color,
    nocombine = true,
  })
end

define_highlight()

local group = vim.api.nvim_create_augroup("VisualRedact", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "InsertLeave", "ModeChanged" }, {
  group = group,
  callback = function(args)
    refresh(args.buf)
  end,
})
vim.api.nvim_create_autocmd("OptionSet", {
  group = group,
  pattern = { "conceallevel", "concealcursor" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if states[bufnr] then
      vim.schedule(function()
        if states[bufnr] and vim.api.nvim_buf_is_valid(bufnr) then
          enable_conceal(bufnr)
          vim.cmd("redraw")
        end
      end)
    end
  end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  callback = function(args)
    local state = states[args.buf]
    if state and has_groups(state) then
      refresh(args.buf, true)
    end
  end,
})
vim.api.nvim_create_autocmd("BufWipeout", {
  group = group,
  callback = function(args)
    states[args.buf] = nil
  end,
})
vim.api.nvim_create_autocmd("WinClosed", {
  group = group,
  callback = function(args)
    local winid = tonumber(args.match)
    for _, state in pairs(states) do
      state.window_options[winid] = nil
    end
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = define_highlight,
})

return M
