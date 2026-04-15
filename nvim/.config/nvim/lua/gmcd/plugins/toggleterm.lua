return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
	},
	opts = {
		shade_terminals = false,
		open_mapping = false,
		float_opts = {
			border = "rounded",
			width = function() return math.floor(vim.o.columns * 0.85) end,
			height = function() return math.floor(vim.o.lines * 0.85) end,
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)
		-- Double-Esc exits terminal mode, then space-tt to dismiss
		vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n><cmd>ToggleTerm<cr>]], { desc = "Dismiss terminal" })
	end,
}
