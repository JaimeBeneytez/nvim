return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript      = { "eslint-lsp" },
				typescript      = { "eslint-lsp" },
				javascriptreact = { "eslint-lsp" },
				typescriptreact = { "eslint-lsp" },
				svelte          = { "eslint-lsp" },
				css             = { "eslint-lsp" },
				html            = { "eslint-lsp" },
				json            = { "eslint-ls" },
				scss            = { "some-sass-language-server" },
				yaml            = { "eslint-lsp" },
				markdown        = { "eslint-lsp" },
				graphql         = { "eslint-lsp" },
				lua             = { "stylua" },
				python          = { "isort", "black" },
			}
		})

		vim.keymap.set({ "n", "v" }, "<leader>fmt", function()
			conform.format({
				lsp_fallback = true,
				async        = false,
				timeout_ms   = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
