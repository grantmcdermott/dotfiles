---@type vim.lsp.Config
return {
	cmd = { "jarl", "server" },
	filetypes = { "r", "rmd" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, { "jarl.toml", ".git" }) or vim.uv.os_homedir())
	end,
}
