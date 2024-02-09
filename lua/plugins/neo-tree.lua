return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = { "MunifTanjim/nui.nvim" },
	keys = {
		{
			"<leader>fe",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
			end,
			desc = "Explorer NeoTree (root dir)",
		},
		{
			"<leader>fE",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
			end,
			desc = "Explorer NeoTree (cwd)",
		},
		{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
		{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)",      remap = true },
		{
			"<leader>ge",
			function()
				require("neo-tree.command").execute({ source = "git_status", toggle = true })
			end,
			desc = "Git explorer",
		},
		{
			"<leader>be",
			function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true })
			end,
			desc = "Buffer explorer",
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		if vim.fn.argc(-1) == 1 then
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			if stat and stat.type == "directory" then
				require("neo-tree")
			end
		end
	end,
	opts = {
		sources = { "filesystem", "buffers", "git_status", "document_symbols" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
		window = {
			mappings = {
				["<space>"] = "none",
				["Y"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.setreg("+", path, "c")
				end,
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				file = "",
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰜌",
				-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
				-- then these will never be used.
				default = "*",
				highlight = "NeoTreeFileIcon"
			},
			name = {
				trailing_slash = true,
			}
		},
		renderers = {
			directory = {
				{ "indent" },
				{ "current_filter" },
				{
					"container",
					content = {
						{ "name",          zindex = 10 },
						{
							"symlink_target",
							zindex = 10,
							highlight = "NeoTreeSymbolicLinkTarget",
						},
						{ "clipboard",     zindex = 10 },
						{ "diagnostics",   errors_only = true, zindex = 20,     align = "right",          hide_when_expanded = true },
						{ "git_status",    zindex = 10,        align = "right", hide_when_expanded = true },
						{ "file_size",     zindex = 10,        align = "right" },
						{ "type",          zindex = 10,        align = "right" },
						{ "last_modified", zindex = 10,        align = "right" },
						{ "created",       zindex = 10,        align = "right" },
					},
				},
			},
			file = {
				{ "indent" },
				{
					"container",
					content = {
						{
							"name",
							zindex = 10
						},
						{
							"symlink_target",
							zindex = 10,
							highlight = "NeoTreeSymbolicLinkTarget",
						},
						{ "clipboard",     zindex = 10 },
						{ "bufnr",         zindex = 10 },
						{ "modified",      zindex = 20, align = "right" },
						{ "diagnostics",   zindex = 20, align = "right" },
						{ "git_status",    zindex = 10, align = "right" },
						{ "file_size",     zindex = 10, align = "right" },
						{ "type",          zindex = 10, align = "right" },
						{ "last_modified", zindex = 10, align = "right" },
						{ "created",       zindex = 10, align = "right" },
					},
				},
			},
			message = {
				{ "indent", with_markers = false },
				{ "name",   highlight = "NeoTreeMessage" },
			},
			terminal = {
				{ "indent" },
				{ "icon" },
				{ "name" },
				{ "bufnr" }
			}
		},
	},
	config = function(_, opts)
		local function on_move(data)
			Util.lsp.on_rename(data.source, data.destination)
		end

		local events = require("neo-tree.events")

		opts.event_handlers = opts.event_handlers or {}

		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED,   handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})

		require("neo-tree").setup(opts)


		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
}
