return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
	},
	opts = {
		shade_terminals = false,
		-- Esc from terminal mode even inside TUI apps
		on_open = function(term)
			vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-q>", "<cmd>ToggleTerm<cr>", { noremap = true })
		end,
		float_opts = {
			border = "rounded",
			width = function() return math.floor(vim.o.columns * 0.85) end,
			height = function() return math.floor(vim.o.lines * 0.85) end,
		},
	},
}
