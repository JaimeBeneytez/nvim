return {
	'mfussenegger/nvim-dap',
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'theHamsta/nvim-dap-virtual-text',
	},
	config = function()
		local dap = require('dap')
		local dapui = require('dapui')

		-- Initialize DAP UI with custom config
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					position = "left",
					size = 40
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 }
					},
					position = "bottom",
					size = 10
				}
			},
		})

		-- Debug event listeners
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
			vim.api.nvim_echo({{"Debug session started", "Normal"}}, false, {})
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			vim.api.nvim_echo({{"Debug session terminated", "WarningMsg"}}, false, {})
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			vim.api.nvim_echo({{"Debug session exited", "WarningMsg"}}, false, {})
		end

		dap.listeners.before.disconnect["dapui_config"] = function()
			vim.api.nvim_echo({{"Debug session disconnected", "WarningMsg"}}, false, {})
		end

		-- Keep UI open until explicitly closed
		dap.listeners.before["event_terminated"]["dapui_config"] = function()
			vim.defer_fn(function()
				dapui.close()
			end, 1000)
		end
		dap.listeners.before["event_exited"]["dapui_config"] = function()
			vim.defer_fn(function()
				dapui.close()
			end, 1000)
		end

		-- Node.js adapter configuration
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = 9230,
			executable = {
				command = "node",
				args = {os.getenv("HOME") .. "/.config/nvim/js-debug/src/dapDebugServer.js", "9230"},
			}
		}

		dap.configurations.typescript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Nx Command",
				program = "./node_modules/.bin/nx",
				args = { "start-dual-rabbit", "fixed-invoices" },
				cwd = "${workspaceFolder}",
				sourceMaps = true,
				protocol = "inspector",
				skipFiles = { "<node_internals>/**" },
				resolveSourceMapLocations = {
					"${workspaceFolder}/**",
					"!**/node_modules/**"
				},
				outFiles = {
					"${workspaceFolder}/dist/**/*.js"
				},
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
		}

		-- Keymaps
		vim.keymap.set('n', '<D-\\>', function() require('dap').continue() end)
		vim.keymap.set('n', "<D-'>", function() require('dap').step_over() end)
		vim.keymap.set('n', '<D-;>', function() require('dap').step_into() end)
		vim.keymap.set('n', '<D-b>', function() require('dap').toggle_breakpoint() end)
		vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
		vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
		-- Toggle debug UI panels
		vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end)

		-- Add visual indicators for breakpoints
		vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
		vim.fn.sign_define('DapBreakpointCondition', {text='🔵', texthl='', linehl='', numhl=''})
		vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
	end,
}
