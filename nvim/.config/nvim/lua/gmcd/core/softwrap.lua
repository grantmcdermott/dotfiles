-- Soft-wrap at a fixed column rather than at the terminal edge.
--
-- Neovim has no option for this: 'wrap' always breaks at the window edge, and
-- 'wrapmargin'/'textwidth' hard-wrap by inserting newlines. So instead we move
-- the edge inward, padding the window with an empty scratch split.

local M = {}

local default_width = 80
local pads = {} -- main window -> pad window

-- Window options that make the pad look like empty margin rather than a buffer.
local pad_opts = {
  number = false,
  relativenumber = false,
  cursorline = false,
  signcolumn = "no",
  foldcolumn = "0",
  statuscolumn = "",
  winfixwidth = true,
  list = false,
}

-- If the pad is the last window left, closing it raises E444. Turn it into an
-- ordinary empty window instead, so you never land in the scratch buffer.
local function promote_pad(pad)
  for opt in pairs(pad_opts) do
    vim.wo[pad][opt] = vim.api.nvim_get_option_value(opt, { scope = "global" })
  end
  vim.api.nvim_win_call(pad, function()
    vim.cmd("enew")
  end)
end

local function drop_pad(pad)
  if not vim.api.nvim_win_is_valid(pad) then
    return
  end
  if not pcall(vim.api.nvim_win_close, pad, true) and vim.api.nvim_win_is_valid(pad) then
    promote_pad(pad)
  end
end

local function close_pad(win, defer)
  local pad = pads[win]
  pads[win] = nil
  if not (pad and vim.api.nvim_win_is_valid(pad)) then
    return
  end
  -- Closing a window from inside WinClosed aborts the original :close (E855),
  -- so the autocmd path has to defer.
  if defer then
    vim.schedule(function()
      drop_pad(pad)
    end)
  else
    drop_pad(pad)
  end
end

-- Width of the gutter (number column, signs, folds) so `width` counts text only.
local function textoff(win)
  local info = vim.fn.getwininfo(win)[1]
  return info and info.textoff or 0
end

local function open_pad(win, width)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false

  local pad = vim.api.nvim_open_win(buf, false, { split = "right", win = win })
  for opt, val in pairs(pad_opts) do
    vim.wo[pad][opt] = val
  end

  pads[win] = pad
  vim.api.nvim_win_set_width(win, width + textoff(win))
  vim.wo[win].winfixwidth = true
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
end

--- Toggle fixed-column soft wrap for the current window.
function M.toggle(width)
  local win = vim.api.nvim_get_current_win()
  if pads[win] then
    close_pad(win)
    vim.wo[win].winfixwidth = false
    vim.cmd("wincmd =")
    return
  end
  width = width or default_width
  if vim.api.nvim_win_get_width(win) <= width + textoff(win) then
    vim.notify("Window is already narrower than " .. width .. " columns", vim.log.levels.INFO)
    return
  end
  open_pad(win, width)
end

-- Drop the pad if its main window goes away.
vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("softwrap_cleanup", { clear = true }),
  callback = function(ev)
    local closed = tonumber(ev.match)
    close_pad(closed, true)
    for main, pad in pairs(pads) do
      if pad == closed then
        pads[main] = nil
        if vim.api.nvim_win_is_valid(main) then
          vim.wo[main].winfixwidth = false
        end
      end
    end
  end,
})

vim.api.nvim_create_user_command("SoftWrap", function(cmd)
  local n = tonumber(cmd.args)
  M.toggle(n and n > 0 and n or nil)
end, { nargs = "?", desc = "Toggle soft wrap at a fixed column (default 80)" })

return M
