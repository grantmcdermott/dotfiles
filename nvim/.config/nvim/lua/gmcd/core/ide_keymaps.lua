-- IDE-style keybindings (Cmd on macOS, Ctrl on Linux)
-- These duplicate vim-native bindings for muscle memory across editors.

local keymap = vim.keymap.set

-- Cmd+/ (macOS) and Ctrl+/ (Linux) to toggle comment
-- Works in normal and visual mode, mirrors VS Code / Positron behaviour
keymap("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment (line)" })
keymap("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment (selection)" })
keymap("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment (line)" })
keymap("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment (selection)" })

-- Send the whole statement under the cursor, so a multi-line expression (e.g. a
-- parenthesised method chain) goes as one unit with no visual selection needed.
-- Mirrors R.nvim / RStudio behaviour.
local function python_send_statement()
	local iron = require("iron.core")
	local ok, node = pcall(vim.treesitter.get_node)
	if not ok or not node or node:type() == "module" then
		iron.send_line() -- no parser, or cursor on a blank line
		return
	end
	-- Climb to the outermost node within the enclosing scope. Stopping at "block"
	-- as well as "module" means a statement inside a def/for/if is sent on its
	-- own, rather than dragging the whole enclosing construct along.
	while
		node:parent()
		and node:parent():type() ~= "module"
		and node:parent():type() ~= "block"
	do
		node = node:parent()
	end
	local srow, _, erow, ecol = node:range()
	if ecol == 0 then
		erow = erow - 1 -- range ends on the line *after* the statement
	end
	iron.send(vim.bo.filetype, vim.api.nvim_buf_get_lines(0, srow, erow + 1, false))
	-- Advance cursor past the statement just sent
	local last = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_win_set_cursor(0, { math.min(erow + 2, last), 0 })
end

-- Cmd+Enter (macOS) and Ctrl+Enter (Linux) to send code to REPL
-- Dispatches to R.nvim for R files, iron.nvim for Python files
local function send_to_repl()
	local ft = vim.bo.filetype
	if ft == "r" or ft == "rmd" or ft == "quarto" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>RDSendLine", true, true, true), "m", false)
	elseif ft == "python" then
		python_send_statement()
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
