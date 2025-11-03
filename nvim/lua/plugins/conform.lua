return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", "eslint_d" },
				typescript = { "prettierd", "prettier", "eslint_d" },
				javascriptreact = { "prettierd", "prettier", "eslint_d" },
				typescriptreact = { "prettierd", "prettier", "eslint_d" },
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
