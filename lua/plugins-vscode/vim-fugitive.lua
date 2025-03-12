return {
	'tpope/vim-fugitive',
	config = function()
		local km = vim.keymap

		km.set('n', '<leader>gs', ':Git<cr>', { desc = 'Git status' })
		km.set('n', '<leader>gd', ':Gdiff<cr>', { desc = 'Git diff' })
		km.set('n', '<leader>gp', ':Git push<cr>', { desc = 'Git push' })
		km.set('n', '<leader>gw', ':Gwrite<cr>', { desc = 'Git write' })
		km.set('n', '<leader>g]', ':diffget //3<cr>', { desc = 'Git diffget //3' })
		km.set('n', '<leader>g[', ':diffget //2<cr>', { desc = 'Git diffget //2' })
	end
}
