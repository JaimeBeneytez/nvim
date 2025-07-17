return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		-- Just set up basic Mason without any advanced features
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Don't use any automatic features from mason-lspconfig that might cause errors
		-- Just load the plugin but don't do any automatic setup
		require("mason-lspconfig")
		
		-- Setup mason-null-ls to install linters and formatters
		require("mason-null-ls").setup({
			ensure_installed = { 
				"jsonlint", 
				"eslint_d", -- Fast ESLint daemon for linting and fixing
			},
			automatic_installation = false,
			handlers = {},
		})
	end,
}
