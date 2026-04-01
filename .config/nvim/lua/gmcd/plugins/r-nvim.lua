return {
	"R-nvim/R.nvim",
	lazy = false,
	-- R.nvim is still young and we may make some breaking changes from time
	-- to time. For now we recommend pinning to the latest minor version
	-- like so:
	version = "~0.1.0",
	opts = {
		-- Create a table with the options to be passed to setup()
		auto_start = "on startup",
		R_args = { "--quiet", "--no-save" },
		hook = {
			on_filetype = function()
				-- This function will be called at the FileType event
				-- of files supported by R.nvim. This is an
				-- opportunity to create mappings local to buffers.
				vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
				vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })

				local wk = require("which-key")
				wk.add({
					buffer = true,
					{ "<localleader>a", group = "all" },
					{ "<localleader>b", group = "between marks" },
					{ "<localleader>c", group = "chunks" },
					{ "<localleader>f", group = "functions" },
					{ "<localleader>g", group = "goto" },
					{ "<localleader>i", group = "install" },
					{ "<localleader>k", group = "knit" },
					{ "<localleader>p", group = "paragraph" },
					{ "<localleader>q", group = "quarto" },
					{ "<localleader>r", group = "r general" },
					{ "<localleader>s", group = "split or send" },
					{ "<localleader>t", group = "terminal" },
					{ "<localleader>v", group = "view" },
				})
			end,
		},
		pdfviewer = "",
	},
	config = function(_, opts)
		vim.g.rout_follow_colorscheme = true
		require("r").setup(opts)
		require("r.pdf.generic").open = vim.ui.open
	end,
}
