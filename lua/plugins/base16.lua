return {
	'RRethy/nvim-base16',
	config = function()
		local base16 = require('base16-colorscheme')

		base16.with_config({
			telescope = true,
			indentblankline = true,
			notify = true,
			ts_rainbow = true,
			cmp = true,
			illuminate = true,
			dapui = true,
		})

		local km = vim.keymap -- for conciseness

		km.set('n', '<leader>dark', ':colorscheme base16-solarized-dark<cr>', { silent = true })
		km.set('n', '<leader>light', ':colorscheme base16-solarized-light<cr>', { silent = true })

		vim.cmd([[colorscheme base16-solarized-dark]])
		vim.cmd([[hi VertSplit guifg=#002b36]])

		vim.api.nvim_set_hl(0, '@lsp.type.function', {})
		vim.api.nvim_set_hl(0, '@lsp.type.class', {})
		vim.api.nvim_set_hl(0, '@lsp.type.decorator', {})
		vim.api.nvim_set_hl(0, '@lsp.type.enum', {})
		vim.api.nvim_set_hl(0, '@lsp.type.enumMember', {})
		vim.api.nvim_set_hl(0, '@lsp.type.function', {})
		vim.api.nvim_set_hl(0, '@lsp.type.interface', {})
		vim.api.nvim_set_hl(0, '@lsp.type.macro', {})
		vim.api.nvim_set_hl(0, '@lsp.type.method', {})
		vim.api.nvim_set_hl(0, '@lsp.type.namespace', {})
		vim.api.nvim_set_hl(0, '@lsp.type.parameter', {})
		vim.api.nvim_set_hl(0, '@lsp.type.property', {})
		vim.api.nvim_set_hl(0, '@lsp.type.struct', {})
		vim.api.nvim_set_hl(0, '@lsp.type.type', {})
		vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', {})
		vim.api.nvim_set_hl(0, '@lsp.type.variable', {})

		local color = base16.colors

		vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = '#002b36', fg = '#999999' })
		vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = 'TelescopeNormal' })
		vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { link = 'TelescopeNormal' })
		vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { link = 'TelescopeNormal' })
		vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { link = 'TelescopeNormal' })
		vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { link = 'TelescopeNormal' })
		vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { link = 'TelescopeNormal' })
		vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { link = 'TelescopeNormal' })
	end

}
