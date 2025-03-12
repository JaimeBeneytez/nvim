return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local function find_editorconfig_indent()
			-- Function to search for .editorconfig and extract indent_size
			local current_dir = vim.fn.getcwd()
			local editorconfig_path = current_dir .. "/.editorconfig"

			while current_dir ~= "/" do
				local file = io.open(editorconfig_path, "r")
				if file then
					-- Read the file line by line to find indent_size
					for line in file:lines() do
						local indent_size = line:match("indent_size%s*=%s*(%d+)")
						if indent_size then
							file:close()
							return tonumber(indent_size)
						end
					end
					file:close()
				end
				-- Move up one directory
				current_dir = vim.fn.fnamemodify(current_dir, ":h")
				editorconfig_path = current_dir .. "/.editorconfig"
			end
			-- Default to 2 spaces if not found
			return 2
		end

		local indent_size = find_editorconfig_indent()

		conform.setup({
			formatters_by_ft = {
				javascript      = { "eslint-lsp"                } ,
				typescript      = { "eslint-lsp"                } ,
				javascriptreact = { "eslint-lsp"                } ,
				typescriptreact = { "eslint-lsp"                } ,
				svelte          = { "eslint-lsp"                } ,
				css             = { "eslint-lsp"                } ,
				html            = { "eslint-lsp"                } ,
				json            = { "jq"                        } ,
				scss            = { "some-sass-language-server" } ,
				yaml            = { "eslint-lsp"                } ,
				markdown        = { "eslint-lsp"                } ,
				graphql         = { "eslint-lsp"                } ,
				lua             = { "stylua"                    } ,
				python          = { "isort", "black"            } ,
			},
			stop_after_first = true, -- New option to stop after the first successful formatter
		})

		vim.keymap.set({ "n", "v" }, "<leader>fmt", function()

			conform.setup({
				-- Define formatters with options
				formatters = {
					jq = {
						cmd = "jq", -- The command to run
						args = { "--indent", tostring(find_editorconfig_indent()) }, -- Custom arguments for jq
						stdin = true, -- Use stdin for input
					},
				}
			})

			conform.format({
				lsp_fallback = true,
				async        = false,
				timeout_ms   = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
