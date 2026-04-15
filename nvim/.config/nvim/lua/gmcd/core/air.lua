-- Air R formatter (https://posit-dev.github.io/air/editor-neovim.html)
local lsp = vim.lsp

lsp.config["air"] = {
	on_attach = function(_, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				lsp.buf.format()
			end,
		})
	end,
}

lsp.enable("air")

-- Disable r_language_server formatting so only Air handles it
lsp.config["r_language_server"] = {
	on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
