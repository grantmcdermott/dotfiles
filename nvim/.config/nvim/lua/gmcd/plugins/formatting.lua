return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        -- svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        -- ruff sorts imports; autopep8 handles layout. autopep8 only fixes actual
        -- PEP 8 violations instead of reflowing, so hand-broken method chains
        -- (e.g. leading-dot polars pipelines) survive a save. ruff_format/black
        -- would collapse any chain that fits within the line limit.
        python = { "ruff_organize_imports", "autopep8" },
        r = { "air" },
        quarto = { "injected" },
        rmd = { "injected" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
      formatters = {
        autopep8 = {
          -- -a -a enables the non-whitespace fixes too; prepend_args also applies
          -- to range formatting (visual-mode <leader>mp)
          prepend_args = { "-a", "-a", "--max-line-length", "88" },
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
