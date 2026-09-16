return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup({})

		-- The main branch dropped `ensure_installed`; parsers are installed via
		-- install(), which needs the tree-sitter CLI >= 0.26.1 on PATH (see README
		-- for per-OS setup). Only ask for what is missing, so startup does no work
		-- in the common case.
		local want = {
			"bash",
			"c",
			"css",
			"dockerfile",
			"gitignore",
			"graphql",
			"html",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"prisma",
			"python",
			"query",
			"r",
			"rnoweb",
			"tsx",
			"vim",
			"vimdoc",
			"yaml",
		}
		local installed = {}
		for _, lang in ipairs(ts.get_installed("parsers")) do
			installed[lang] = true
		end
		local missing = vim.tbl_filter(function(lang)
			return not installed[lang]
		end, want)
		if #missing > 0 then
			-- Fail loudly. A missing CLI otherwise degrades silently: parsers never
			-- build, highlighting never starts, and anything treesitter-backed
			-- (e.g. Cmd+Enter statement sending) quietly falls back.
			if vim.fn.executable("tree-sitter") == 0 then
				vim.notify(
					("nvim-treesitter: %d parser(s) missing (%s) but the tree-sitter CLI was not found on PATH. Install tree-sitter-cli >= 0.26.1; see README."):format(
						#missing,
						table.concat(missing, ", ")
					),
					vim.log.levels.WARN
				)
			else
				ts.install(missing)
			end
		end

		-- The main branch also stopped enabling highlighting itself; start it per
		-- buffer, but only where a parser actually exists so unsupported filetypes
		-- do not error on open.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if lang and vim.treesitter.language.add(lang) then
					pcall(vim.treesitter.start, args.buf, lang)
				end
			end,
		})
	end,
}
