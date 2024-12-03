return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim"
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			handlers = {
					["tsserver"] = function() end, -- handled by `typescript_tools.lua`
			}, 
		})

	end,
}
