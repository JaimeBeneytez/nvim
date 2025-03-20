return {
	'mfussenegger/nvim-dap',
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'theHamsta/nvim-dap-virtual-text',
		'rcarriga/cmp-dap',
		'nvim-cmp'
	},
	config = function()
		local dap = require('dap')
		local dapui = require('dapui')
		local cmp = require('cmp')

		cmp.setup({
      sources = {
        { name = "dap" }
      }
    })

		-- Initialize DAP UI with custom config
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "console", size = 0.5 },
						{ id = "scopes", size = 0.5 }
					},
					position = "bottom",
					size = 20
				}
			},
			floating = {
				border = "rounded",
			},
			render = {
				indent = 2,
				max_value_lines = 50,
				max_type_length = 0
			}
		})

		-- Automatically open UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
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
				name = "Debug Command",
				program = function()
					local cmd = vim.g.debug_command
					if not cmd then return "./node_modules/.bin/nx" end
					local parts = {}
					for part in cmd:gmatch("%S+") do
						table.insert(parts, part)
					end
					return parts[1]
				end,
				args = function()
					local cmd = vim.g.debug_command
					if not cmd then
						return { "start-dual-rabbit", "fixed-invoices" }
					end
					local parts = {}
					local first = true
					for part in cmd:gmatch("%S+") do
						if not first then
							table.insert(parts, part)
						end
						first = false
					end
					return parts
				end,
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

		local function open_modal(element)
			dapui.float_element(element, {
				width = 300,
				enter = true,
				position = 'center'
			})
		end

		-- Keymaps
		vim.keymap.set('n', '<D-\\>', function() require('dap').continue() end)
		vim.keymap.set('n', "<D-'>", function() require('dap').step_over() end)
		vim.keymap.set('n', '<D-;>', function() require('dap').step_into() end)
		vim.keymap.set('n', '<D-b>', function() require('dap').toggle_breakpoint() end)
		vim.keymap.set('n', '<Leader>db', function() open_modal('breakpoints') end)
		vim.keymap.set('n', '<Leader>dt', function() open_modal('stacks') end)
		vim.keymap.set('n', '<Leader>dw', function() open_modal('watches') end)
		vim.keymap.set('n', '<Leader>dx', function() open_modal('expressions') end)
		vim.keymap.set('n', '<Leader>de', function() dapui.eval() end )

		vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
		vim.keymap.set('n', '<Leader>du', function() dapui.toggle() end)
		-- Add visual indicators for breakpoints
		vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
		vim.fn.sign_define('DapBreakpointCondition', {text='🔵', texthl='', linehl='', numhl=''})
		vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})

		-- Create debug command
		vim.api.nvim_create_user_command('Debug', function(opts)
			vim.g.debug_command = opts.args
			-- Print the command for debugging
			print("Debug command: " .. vim.g.debug_command)
			
			-- Start the debugger
			local dap = require('dap')
			
			-- Make sure we're using the right configuration
			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug Command",
					program = function()
						local cmd = vim.g.debug_command
						if not cmd then return "./node_modules/.bin/nx" end
						local parts = {}
						for part in cmd:gmatch("%S+") do
							table.insert(parts, part)
						end
						-- Print the program for debugging
						print("Program: " .. parts[1])
						if parts[1] == "nx" then
							return "./node_modules/.bin/nx"
						elseif parts[1] == "ng" then
							return "./node_modules/.bin/ng"
						else
							return parts[1]
						end
					end,
					args = function()
						local cmd = vim.g.debug_command
						if not cmd then
							return { "start-dual-rabbit", "fixed-invoices" }
						end
						local parts = {}
						local first = true
						for part in cmd:gmatch("%S+") do
							if not first then
								table.insert(parts, part)
							end
							first = false
						end
						-- Print the args for debugging
						print("Args: " .. vim.inspect(parts))
						return parts
					end,
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
				}
			}
			
			-- Ensure the configuration is set for JavaScript files too
			dap.configurations.javascript = dap.configurations.typescript
			
			-- Start debugging
			dap.continue()
		end, {
			nargs = '+',
			complete = function(_, _, _)
				return {
					'ng serve',
					'nx start-dual-rabbit fixed-invoices',
					'nx bdd fixed-invoices',
					'nx test business'
				}
			end
		})
	end,
}
