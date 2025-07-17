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
		local telescope_builtin = require('telescope.builtin')
		local actions = require('telescope.actions')

		telescope.setup({
			defaults = {
				hidden = true,
				layout_strategy = 'horizontal',
				layout_config = {
					prompt_position = 'bottom',
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
					'%.nx/.*',
					'%.git/.*',
					'%.data/.*',
					'%.cursor/.*',
					'%.vscode/.*',
					'dist/.*',
					'node_modules/.*',
					'tmp/.*',
					'package%-lock%.json'
				},
				vimgrep_arguments = {
					'rg',
					'--color=never',
					'--no-heading',
					'--with-filename',
					'--line-number',
					'--column',
					'--smart-case',
					'--hidden',
					'--glob=!.git/',
					'--glob=!.nx/',
					'--glob=!.data/',
					'--glob=!.cursor/',
					'--glob=!.vscode/',
					'--glob=!dist/',
					'--glob=!node_modules/',
					'--glob=!tmp/',
					'--glob=!package-lock.json'
				}
			},
			pickers = {
				find_files = {
					hidden = true
				},
				live_grep = {
					hidden = true
				},
				grep_string = {
					hidden = true
				}
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				}
			}
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
		keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Fuzzy find files in cwd' })
		keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Fuzzy find buffers' })
		keymap.set('n', '<leader>fs', telescope_builtin.live_grep, { desc = 'Find string in cwd' })
		keymap.set('n', '<leader>fc', telescope_builtin.grep_string, { desc = 'Find string under cursor in cwd' })
		keymap.set('n', '<leader>fw', 'yaw :Ggrep <C-R><C-W><cr><cr> :copen <cr>', { desc = 'Grep word under cursor' }) --@TODO: Move to telescope
		keymap.set('n', '<leader>fr', telescope_builtin.lsp_references, { desc = 'Fuzzy find references' }) 
	end,
}
