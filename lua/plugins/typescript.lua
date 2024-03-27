return {
	"jose-elias-alvarez/typescript.nvim",
	config = function()
		local ts = require("typescript")

		-- Keymaps
		local keymap = vim.keymap
		keymap.set('n', '<leader>oi', ts.actions.organizeImports, { desc = 'TS organize imports' })
		keymap.set('n', '<leader>ai', ts.actions.addMissingImports, { desc = 'TS add missing imports' })
		keymap.set('n', '<leader>fa', ts.actions.fixAll, { desc = 'TS fix all' })
		keymap.set('n', '<leader>ru', ts.actions.removeUnused, { desc = 'TS remove unused members' })
	end
}
