return {
	'tpope/vim-surround',
	config = function()
		local km = vim.keymap
		km.set('n', '<leader>s', 'ysiw', { silent = true })
	end
}
