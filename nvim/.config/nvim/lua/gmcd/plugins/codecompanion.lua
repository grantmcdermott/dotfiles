-- Set CODECOMPANION_AGENT in ~/.zshrc.local to "kiro" or "claude_code"
local agent = vim.env.CODECOMPANION_AGENT

if not agent then
	local msg = 'CodeCompanion: set CODECOMPANION_AGENT in ~/.zshrc.local (e.g. "kiro" or "claude_code")'
	return {
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",
		keys = {
			{ "<leader>aa", function() vim.notify(msg, vim.log.levels.WARN) end, mode = { "n", "v" }, desc = "Action palette (not configured)" },
		},
	}
end

return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCLI", "CodeCompanionActions" },
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action palette" },
		{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle chat" },
		{ "<leader>ai", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New chat" },
		{ "<leader>al", "<cmd>CodeCompanionCLI<cr>", desc = "Open CLI agent" },
		{ "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to chat" },
	},
	opts = {
		interactions = {
			chat = {
				adapter = agent,
			},
		},
	},
}
