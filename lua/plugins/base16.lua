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
		local set_hl = vim.api.nvim_set_hl
		local grey = '#2f4f4f'

		vim.cmd([[colorscheme base16-solarized-dark]])

		-- Enable line numbers
		vim.opt.number = true
		vim.opt.cursorline = true

		km.set('n', '<leader>dark', ':colorscheme base16-solarized-dark<cr>', { silent = true })
		km.set('n', '<leader>light', ':colorscheme base16-solarized-light<cr>', { silent = true })

		-- vim.cmd([[hi VertSplit guifg=#002b36]])
		set_hl(0, 'WinSeparator', { fg = grey })
		set_hl(0, 'LineNr', { fg = grey })
		set_hl(0, 'CursorLine', { bg = '#002b36' })
		set_hl(0, 'CursorLineNr', { fg = '#93a1a1', bold = true })
		set_hl(0, 'SignColumn', { bg = 'none' })
		set_hl(0, '@lsp.type.function', {})
		set_hl(0, '@lsp.type.class', {})
		set_hl(0, '@lsp.type.decorator', {})
		set_hl(0, '@lsp.type.enum', {})
		set_hl(0, '@lsp.type.enumMember', {})
		set_hl(0, '@lsp.type.interface', {})
		set_hl(0, '@lsp.type.macro', {})
		set_hl(0, '@lsp.type.method', {})
		set_hl(0, '@lsp.type.namespace', {})
		set_hl(0, '@lsp.type.parameter', {})
		set_hl(0, '@lsp.type.property', {})
		set_hl(0, '@lsp.type.struct', {})
		set_hl(0, '@lsp.type.type', {})
		set_hl(0, '@lsp.type.typeParameter', {})
		set_hl(0, '@lsp.type.variable', {})

		local color = base16.colors

		set_hl(0, 'TelescopeNormal', { bg = '#002b36', fg = '#999999' })
		set_hl(0, 'TelescopeBorder', { link = 'TelescopeNormal' })
		set_hl(0, 'TelescopePromptBorder', { link = 'TelescopeNormal' })
		set_hl(0, 'TelescopePromptNormal', { link = 'TelescopeNormal' })
		set_hl(0, 'TelescopePromptPrefix', { link = 'TelescopeNormal' })
		set_hl(0, 'TelescopePromptTitle', { link = 'TelescopeNormal' })
		set_hl(0, 'TelescopeResultsTitle', { link = 'TelescopeNormal' })
		set_hl(0, 'TelescopePreviewTitle', { link = 'TelescopeNormal' })
	end

}
