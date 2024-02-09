return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript      = { "eslint" },
				typescript      = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				svelte          = { "eslint" },
				css             = { "eslint" },
				html            = { "eslint" },
				json            = { "eslint" },
				yaml            = { "eslint" },
				markdown        = { "eslint" },
				graphql         = { "eslint" },
				lua             = { "stylua" },
				python          = { "isort", "black" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async        = false,
				timeout_ms   = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
