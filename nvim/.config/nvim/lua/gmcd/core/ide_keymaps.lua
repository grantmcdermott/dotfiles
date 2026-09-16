-- IDE-style keybindings (Cmd on macOS, Ctrl on Linux)
-- These duplicate vim-native bindings for muscle memory across editors.

local keymap = vim.keymap.set

-- Cmd+/ (macOS) and Ctrl+/ (Linux) to toggle comment
-- Works in normal and visual mode, mirrors VS Code / Positron behaviour
keymap("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment (line)" })
keymap("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment (selection)" })
keymap("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment (line)" })
keymap("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment (selection)" })

-- Park the cursor on the next non-blank line at or after `lnum`, so repeated
-- sends walk down the buffer as they do in RStudio. Clamps at the last line.
local function advance_cursor(lnum)
	local last = vim.api.nvim_buf_line_count(0)
	lnum = math.min(lnum, last)
	while lnum < last and vim.fn.getline(lnum):match("^%s*$") do
		lnum = lnum + 1
	end
	vim.api.nvim_win_set_cursor(0, { lnum, 0 })
end

-- Send the whole statement under the cursor, so a multi-line expression (e.g. a
-- parenthesised method chain) goes as one unit with no visual selection needed.
-- Mirrors R.nvim / RStudio behaviour.
local function python_send_statement()
	local iron = require("iron.core")
	-- get_node reads an already-parsed tree, so force a parse first rather than
	-- relying on highlighting having painted this buffer yet.
	pcall(function()
		vim.treesitter.get_parser(0):parse()
	end)
	local ok, node = pcall(vim.treesitter.get_node)
	if not ok or not node or node:type() == "module" then
		-- no parser, or cursor on a blank line
		iron.send_line()
		advance_cursor(vim.fn.line(".") + 1)
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
	advance_cursor(erow + 2)
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
		-- Read the selection end while still in visual mode; '> is not set until exit
		local last_selected = math.max(vim.fn.line("v"), vim.fn.line("."))
		require("iron.core").visual_send()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
		vim.schedule(function()
			advance_cursor(last_selected + 1)
		end)
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
