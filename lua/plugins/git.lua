return {
	'tpope/vim-fugitive',
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup({
				signs = {
					add = { text = '+' },
					change = { text = '~' },
					delete = { text = '_' },
					topdelete = { text = '‾' },
					changedelete = { text = '~' },
				},
				-- Enable current line blame to show commit info when cursor is on a line
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 300,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					-- Navigation
					vim.keymap.set('n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.next_hunk() end)
						return '<Ignore>'
					end, {expr=true, buffer=bufnr})
					vim.keymap.set('n', '[c', function()
						if vim.wo.diff then return '[c' end
						vim.schedule(function() gs.prev_hunk() end)
						return '<Ignore>'
					end, {expr=true, buffer=bufnr})
					-- Actions
					vim.keymap.set({'n', 'v'}, '<leader>hs', gs.stage_hunk)
					vim.keymap.set({'n', 'v'}, '<leader>hr', gs.reset_hunk)
					vim.keymap.set('n', '<leader>hS', gs.stage_buffer)
					vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk)
					vim.keymap.set('n', '<leader>hR', gs.reset_buffer)
					vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
					vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end)
					vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
					vim.keymap.set('n', '<leader>hd', gs.diffthis)
					vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)
					vim.keymap.set('n', '<leader>td', gs.toggle_deleted)
					-- Text object
					vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
					end,
			})
		end,
	},
}
