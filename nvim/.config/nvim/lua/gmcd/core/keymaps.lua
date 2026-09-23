-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- swap q and Q: use Q to record macros, disable default Ex mode on Q
keymap.set("n", "Q", "q", { desc = "Record macro" })
keymap.set("n", "q", "<Nop>", { desc = "Disable default macro recording" })

-- disable Ex mode and macro recording (prevent accidental Q/q)
keymap.set("n", "Q", "<Nop>", { desc = "Disable Ex mode" })
keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- buffer management
keymap.set("n", "<leader>bl", "<cmd>Telescope buffers<CR>", { desc = "List buffers" }) -- fuzzy-find open buffers
keymap.set("n", "<leader>bb", "<cmd>b#<CR>", { desc = "Go to alternate buffer" }) -- toggle last two buffers
keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" }) -- follows bufferline order, not buffer number
keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
-- close all but current; skips modified and unlisted (terminal, REPL) buffers
keymap.set("n", "<leader>bo", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= cur and vim.bo[buf].buflisted and not vim.bo[buf].modified then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { desc = "Delete other buffers" })

-- soft wrap at column 80 instead of the terminal edge
keymap.set("n", "<leader>sw", "<cmd>SoftWrap<CR>", { desc = "Toggle soft wrap at 80 columns" })

-- tilde and backticks
vim.api.nvim_set_keymap("i", "<A-/>", "~", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "a'", "``<Esc>i", { noremap = true, silent = true })
