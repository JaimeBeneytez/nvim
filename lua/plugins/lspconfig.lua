return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"b0o/schemastore.nvim", -- For JSON schema support
	},
	config = function()
		-- Basic LSP setup
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		
		-- Enable JSON formatting and linting via JSONLS
		local on_attach = function(client, bufnr)
			-- Format on save for JSON files
			if client.server_capabilities.documentFormattingProvider then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
					buffer = bufnr,
					callback = function()
						if vim.bo.filetype == "json" or vim.bo.filetype == "jsonc" then
							vim.lsp.buf.format({ async = false })
						end
					end
				})
				
				-- Format with keymaps
				vim.keymap.set("n", "<leader>fmt", function()
					vim.lsp.buf.format({ async = true })
				end, { buffer = bufnr, desc = "Format with LSP" })
			end

			-- Auto-fix keymap
			vim.keymap.set("n", "<leader>fa", function()
				vim.lsp.buf.code_action({
					filter = function(a)
						return a.kind and string.find(a.kind, "quickfix") or
						      (a.title and a.title:find("Fix"))
					end,
					apply = true
				})
			end, { buffer = bufnr, desc = "Auto-fix all errors" })

			-- Diagnostic navigation
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
			vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = bufnr })
		end

		-- Try to use schemastore if available, otherwise use empty schemas
		local schemas = {}
		local has_schemastore, schemastore = pcall(require, "schemastore")
		if has_schemastore then
			schemas = schemastore.json.schemas()
		end

		-- Configure JSON Language Server
		require("lspconfig").jsonls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "json", "jsonc" },
			settings = {
				json = {
					schemas = schemas,
					validate = { enable = true },
					format = { enable = true },
				}
			}
		})
	end,
}
