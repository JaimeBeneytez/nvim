return {
	"David-Kunz/jester",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function()
		local jester = require("jester")

		jester.setup({
			cmd = "./node_modules/.bin/jest --runInBand -t '$result' -- $file", -- run command
			identifiers = { "test", "it" },                            -- used to identify tests
			prepend = { "describe" },                                  -- prepend describe blocks
			expressions = { "call_expression" },                       -- tree-sitter object used to scan for tests/describe blocks
			path_to_jest_run = 'jest',                                 -- used to run tests
			path_to_jest_debug = './node_modules/.bin/jest',           -- used for debugging
			terminal_cmd = ":vsplit | terminal",                       -- used to spawn a terminal for running tests, for debugging refer to nvim-dap's config
			dap = {                                                    -- debug adapter configuration
				request = 'launch',
				cwd = vim.fn.getcwd(),
				runtimeArgs = { '--inspect-brk', '$path_to_jest', '--no-coverage', '-t', '$result', '--', '$file' },
				type = 'chrome',
				args = { '--no-cache' },
				sourceMaps = false,
				protocol = 'inspector',
				skipFiles = { '<node_internals>/**/*.js' },
				console = 'externalTerminal',
				port = 9229,
				disableOptimisticBPs = true
			}
		})

		-- local dap = require('dap')
		--
		-- dap.adapters.node2 = {
		-- 	type = 'executable',
		-- 	command = 'node',
		-- 	args = { os.getenv('HOME') .. '/work/misc/vscode-node-debug2/out/src/nodeDebug.js' },
		-- }
		-- dap.configurations.javascript = {
		-- 	{
		-- 		name = 'Launch',
		-- 		type = 'node2',
		-- 		request = 'launch',
		-- 		program = '${file}',
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = 'inspector',
		-- 		console = 'integratedTerminal',
		-- 	},
		-- 	{
		-- 		-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		-- 		name = 'Attach to process',
		-- 		type = 'node2',
		-- 		request = 'attach',
		-- 		processId = require 'dap.utils'.pick_process,
		-- 	},
		-- }
		--
		-- dap.adapters.chrome = {
		-- 	type = "executable",
		-- 	command = "node",
		-- 	args = { os.getenv("HOME") .. "/work/misc/vscode-chrome-debug/out/src/chromeDebug.js" } -- TODO adjust
		-- }
		--
		-- dap.configurations.javascript = { -- change this to javascript if needed
		-- 	{
		-- 		type = "chrome",
		-- 		request = "attach",
		-- 		program = "${file}",
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = "inspector",
		-- 		port = 9222,
		-- 		webRoot = "${workspaceFolder}"
		-- 	}
		-- }
		--
		-- dap.configurations.typescript = { -- change to typescript if needed
		-- 	{
		-- 		type = "chrome",
		-- 		request = "attach",
		-- 		program = "${file}",
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = "inspector",
		-- 		port = 9222,
		-- 		webRoot = "${workspaceFolder}"
		-- 	}
		-- }

		local function configureDebuggerAngular(dap)
			dap.adapters.chrome = {
				-- executable: launch the remote debug adapter - server: connect to an already running debug adapter
				type = "executable",
				-- command to launch the debug adapter - used only on executable type
				command = "node",
				args = { os.getenv("HOME") .. "/work/misc/vscode-chrome-debug/out/src/chromeDebug.js" }
			}

			-- The configuration must be named: typescript
			dap.configurations.typescript = {
				{
					name = "Debug (Attach) - Remote",
					type = "chrome",
					request = "attach",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					reAttach = true,
					trace = true,
					protocol = "inspector",
					hostName = "127.0.0.1",
					port = 9229,
					webRoot = "$file"
				}
			}
		end

		local function configureDap()
			local status_ok, dap = pcall(require, "dap")

			if not status_ok then
				print("The dap extension could not be loaded")
				return
			end

			dap.set_log_level("DEBUG")

			-- vim.highlight.create('DapBreakpoint', { ctermbg = 0, guifg = '#993939', guibg = '#31353f' }, false)
			-- vim.highlight.create('DapLogPoint', { ctermbg = 0, guifg = '#61afef', guibg = '#31353f' }, false)
			-- vim.highlight.create('DapStopped', { ctermbg = 0, guifg = '#98c379', guibg = '#31353f' }, false)
			--
			vim.fn.sign_define('DapBreakpoint', {
				text = '',
				texthl = 'DapBreakpoint',
				linehl = 'DapBreakpoint',
				numhl = 'DapBreakpoint'
			})
			vim.fn.sign_define('DapBreakpointCondition',
				{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
			vim.fn.sign_define('DapBreakpointRejected',
				{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
			vim.fn.sign_define('DapLogPoint',
				{ text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
			vim.fn.sign_define('DapStopped',
				{ text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

			return dap
		end

		local function configure()
			local dap = configureDap()

			if nil == dap then
				print("The DAP core debugger could not be set")
			end

			configureDebuggerAngular(dap)
		end

		configure()
	end,
}
