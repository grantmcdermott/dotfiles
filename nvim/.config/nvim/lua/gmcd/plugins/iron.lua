return {
	"Vigemus/iron.nvim",
	ft = { "python" },
	config = function()
		local bracketed = require("iron.fts.common").bracketed_paste_python
		local has_ipython = os.execute("uv run ipython --version >/dev/null 2>&1") == 0
		local repl
		if has_ipython then
			repl = {
				command = { "uv", "run", "ipython", "--no-autoindent" },
				format = bracketed,
			}
		else
			repl = {
				command = { "uv", "run", "python" },
				format = bracketed,
			}
		end
		require("iron.core").setup({
			config = {
				repl_definition = {
					python = repl,
				},
				repl_open_cmd = "vertical botright 80 split",
			},
		})
	end,
}
