return {
	'mfussenegger/nvim-dap',
	config = function()
		local dap = require('dap')

		dap.adapters["node2"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {"~/.config/nvim/js-debug/src/dapDebugServer.js", "${port}"},
			}
		}

		dap.configurations.javascript = {
			{
				type = "node2",
				request = "launch",
				name = "Launch Program",
				skipFiles = {"<node_internals>/**"},
				program = "${file}",
			},
		}

		dap.configurations.typescript = {
			{
				type = "node2",
				request = "launch",
				name = "Launch Program",
				skipFiles = {"<node_internals>/**"},
				program = "${file}",
			},
		}

	end,
}
