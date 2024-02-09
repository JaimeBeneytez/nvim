return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'sharkdp/fd',
		'BurntSushi/ripgrep',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')

		telescope.setup({
			defaults = {
				layout_config = {
					prompt_position = 'bottom',
					preview_width = 0.6,
					preview_height = 0.6,
				},
				path_display = { 'truncate' },
				mappings = {
					i = {
						['<C-k>'] = actions.move_selection_previous, -- move to prev result
						['<C-j>'] = actions.move_selection_next, -- move to next result
						['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = {
					'node%_modules/.*',
					'dist/.*',
					'.git/.*'
				}

			},
		})

		telescope.load_extension('fzf')

		local _border = "single"

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
			vim.lsp.handlers.hover, { border = _border }
		)

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
			vim.lsp.handlers.signature_help, { border = _border }
		)

		vim.diagnostic.config {
			float = { border = _border }
		}

		-- Keymaps
		local keymap = vim.keymap
		keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
		keymap.set('n', '<leader>fb', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
		keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Fuzzy find recent files' })
		keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<cr>', { desc = 'Find string in cwd' })
		keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string under cursor in cwd' })
		keymap.set('n', '<leader>fw', 'yaw :Ggrep <C-R><C-W><cr><cr> :copen <cr>', { desc = 'Grep word under cursor' }) --@TODO: Move to telescope
	end,
}
