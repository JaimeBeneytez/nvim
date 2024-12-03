return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
	config = function()

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("typescript-tools").setup({
			organize_imports = true,
			enable_formatting = true,
			lspconfig = {
				capabilities = capabilities,
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
			},
			settings = {
				includeInlayVariableTypeHints = false,
				code_lens = "off",
				disable_member_code_lens = true,
			}
		})

		local km = vim.keymap

		km.set('n' , '<leader>oi' , ':TSToolsOrganizeImports<CR>'      , { desc = 'TS organize imports' })
		km.set('n' , '<leader>ai' , ':TSToolsAddMissingImports<CR>'    , { desc = 'TS add missing imports' })
		km.set('n' , '<leader>fa' , ':TSToolsFixAll<CR>'               , { desc = 'TS fix all' })
		km.set('n' , '<leader>ru' , ':TSToolsRemoveUnusedImports<CR>'  , { desc = 'TS remove unused members' })
		km.set('n', 'gd', function()
			local ts_tools = require("typescript-tools")
			if ts_tools then
				vim.cmd("TSToolsGoToSourceDefinition")
			else
				vim.lsp.buf.definition() -- Fallback to the default LSP behavior
			end
		end, { desc = "Go to definition (typescript-tools or fallback)" })

	end,
}
