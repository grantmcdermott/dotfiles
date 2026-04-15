-- IDE-style keybindings (Cmd on macOS, Ctrl on Linux)
-- These duplicate vim-native bindings for muscle memory across editors.

local keymap = vim.keymap.set

-- Cmd+/ (macOS) and Ctrl+/ (Linux) to toggle comment
-- Works in normal and visual mode, mirrors VS Code / Positron behaviour
keymap("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment (line)" })
keymap("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment (selection)" })
keymap("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment (line)" })
keymap("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment (selection)" })

-- Cmd+Enter (macOS) and Ctrl+Enter (Linux) to send code to REPL
-- Dispatches to R.nvim for R files, toggleterm for Python files
local function send_to_repl()
	local ft = vim.bo.filetype
	if ft == "r" or ft == "rmd" or ft == "quarto" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>RDSendLine", true, true, true), "m", false)
	elseif ft == "python" then
		require("iron.core").send_line()
		-- Advance cursor to next line
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local last = vim.api.nvim_buf_line_count(0)
		if row < last then
			vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
		end
	end
end

local function send_selection_to_repl()
	local ft = vim.bo.filetype
	if ft == "r" or ft == "rmd" or ft == "quarto" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>RSendSelection", true, true, true), "m", false)
	elseif ft == "python" then
		require("iron.core").visual_send()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
	end
end

keymap("n", "<D-CR>", send_to_repl, { desc = "Send line to REPL" })
keymap("v", "<D-CR>", send_selection_to_repl, { desc = "Send selection to REPL" })
keymap("n", "<C-CR>", send_to_repl, { desc = "Send line to REPL" })
keymap("v", "<C-CR>", send_selection_to_repl, { desc = "Send selection to REPL" })

-- Start R with <space>rr (R filetypes only)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "r", "rmd", "quarto" },
	callback = function()
		vim.keymap.set("n", "<leader>rr", "<Plug>RStart", { buffer = true, desc = "Start R" })
	end,
})
