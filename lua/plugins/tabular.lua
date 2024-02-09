return {
	'godlygeek/tabular',
	config = function()
		local km = vim.keymap

		km.set('v', '<leader>t:', 'Tabularize /:<cr>', { silent = true })
		km.set('v', '<leader>t=', 'Tabularize /=<cr>', { silent = true })
		km.set('v', '<leader>t.', 'Tabularize /.<cr>', { silent = true })
		km.set('v', '<leader>t,', 'Tabularize /,<cr>', { silent = true })
		km.set('v', '<leader>t(', 'Tabularize /(<cr>', { silent = true })
		km.set('v', '<leader>t)', 'Tabularize /)<cr>', { silent = true })
		km.set('v', '<leader>t()', 'Tabularize /(<cr> :Tabularize /)<cr>', { silent = true })
		km.set('v', '<leader>t{', 'Tabularize /{<cr>', { silent = true })
		km.set('v', '<leader>t}', 'Tabularize /}<cr>', { silent = true })
		km.set('v', '<leader>t{}', 'Tabularize /{<cr> :Tabularize /}<cr>', { silent = true })
		km.set('v', '<leader>t[', 'Tabularize /[<cr>', { silent = true })
		km.set('v', '<leader>t]', 'Tabularize /]<cr>', { silent = true })
		km.set('v', '<leader>t|', 'Tabularize /|<cr>', { silent = true })
		km.set('v', '<leader>t||', 'Tabularize /||<cr>', { silent = true })
		km.set('v', '<leader>tfrom', 'Tabularize /from<cr>', { silent = true })
		km.set('v', '<leader>t+', 'Tabularize /+<cr>', { silent = true })
		km.set('v', '<leader>t`', 'Tabularize /`<cr>', { silent = true })
		km.set('v', '<leader>t"', 'Tabularize /"<cr>', { silent = true })
		km.set('v', '<leader>t<', 'Tabularize /<<cr>', { silent = true })
		km.set('v', '<leader>t>', 'Tabularize /><cr>', { silent = true })
		km.set('v', '<leader>t<>', 'Tabularize /<<cr> :Tabularize /><cr>', { silent = true })
		km.set("v", "<leader>t'", "Tabularize /'<cr>", { silent = true })
	end,
}
