return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		
		-- Create a custom formatter for jq
		local jq = {
			method = null_ls.methods.FORMATTING,
			filetypes = { "json", "jsonc" },
			generator = null_ls.generator({
				command = "jq",
				args = { "--indent", "2", "." },
				to_stdin = true,
				from_stderr = false,
				on_output = function(output, params)
					return output
				end,
			}),
		}
		
		-- We'll use eslint_d only for formatting and fixing
		-- This is more efficient and avoids issues with telescope
		
		-- Create simple eslint_d formatter (more efficient)
		local eslint_d_formatter = {
			method = null_ls.methods.FORMATTING,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			generator = null_ls.generator({
				command = "eslint_d",
				args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
				to_stdin = true,
			}),
			fifo_timeout = 10000, -- increased timeout for larger files
		}
		
		-- Lightweight eslint_d code actions
		local eslint_d_code_actions = {
			method = null_ls.methods.CODE_ACTION,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			generator = {
				fn = function(params)
					local actions = {}
					table.insert(actions, {
						title = "Fix all eslint issues",
						action = function()
							-- Use eslint_d to fix the file
							local bufname = params.bufname
							local cmd = string.format("eslint_d --fix '%s'", bufname)
							vim.fn.system(cmd)
							-- Reload the buffer
							vim.cmd("edit")
							vim.notify("Fixed with eslint_d", vim.log.levels.INFO)
						end
					})
					return actions
				end,
			},
		}
		
		-- Create custom jsonlint diagnostics source
		local jsonlint = {
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "json", "jsonc" },
			generator = null_ls.generator({
				command = "jsonlint",
				args = { "-c", "$FILENAME" },  -- Use -c for compact output
				to_stdin = false,
				from_stderr = true,
				on_output = function(err, params)
					if not err or err == "" then
						return {}
					end
					
					local diagnostics = {}
					-- Sample error format: "[filename]:line:column: message"
					local line, col, msg = err:match(":%s*(%d+):(%d+):%s*(.+)")
					if line and col and msg then
						local line_num = tonumber(line)
						local col_num = tonumber(col)
						table.insert(diagnostics, {
							row = line_num,
							col = col_num,
							end_row = line_num,
							end_col = col_num + 1,
							source = "jsonlint",
							message = msg,
							severity = 1, -- Error
						})
					end
					
					return diagnostics
				end,
			}),
		}
		
		-- Add dedicated command and keymaps for JSON formatting
		local function format_json_with_jq()
			-- Try to format using jq
			local bufnr = vim.api.nvim_get_current_buf()
			local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local text = table.concat(content, "\n")
			
			-- Save file first if needed
			if vim.bo.modified then
				vim.cmd("silent write")
			end
			
			-- Use jq to format JSON content
			local job = vim.fn.jobstart({"jq", "--indent", "2", "."}, {
				stdin_buffered = true,
				stdout_buffered = true,
				on_stdout = function(_, data)
					if data and #data > 1 then
						-- Remove the last empty line if present
						if data[#data] == "" then
							table.remove(data, #data)
						end
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
					end
				end,
				on_stderr = function(_, data)
					-- If there's an error from jq, show it
					if data and #data > 1 and data[1] ~= "" then
						vim.notify("JSON format error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
					end
				end
			})
			
			-- Send content to jq
			if job then
				vim.fn.chansend(job, text)
				vim.fn.chanclose(job, "stdin")
				vim.notify("JSON formatted with jq", vim.log.levels.INFO)
			end
		end
		
		-- Create dedicated Neovim command for JSON formatting
		vim.api.nvim_create_user_command("JsonFormat", function()
			format_json_with_jq()
		end, {})
		
		-- Set up JSON-specific keybindings
		local json_augroup = vim.api.nvim_create_augroup("json_format", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = json_augroup,
			pattern = {"json", "jsonc"},
			callback = function()
				-- Only keep the <leader>fmt keybinding as requested by the user
				vim.keymap.set("n", "<leader>fmt", function()
					vim.cmd("JsonFormat")
				end, { buffer = true, desc = "Format JSON with jq" })
			end,
		})
		

		-- Register sources
		null_ls.setup({
			sources = {
				-- Custom JSON linting with jsonlint for diagnostics
				jsonlint,
				
				-- Custom jq formatter
				jq,
				
				-- Custom eslint_d formatter (lightweight)
				eslint_d_formatter,
				
				-- Add code actions for eslint_d
				eslint_d_code_actions,
			},
			debug = false,
			-- Attach diagnostics, formatting, and code actions only if eslintrc file exists
			cond = function(utils)
				return utils.root_has_file({
					".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs",
					".eslintrc.yml", ".eslintrc.yaml"
				})
			end
		})
		
		-- Create a custom auto-fix function for JSON files
		local function fix_json_file()
			-- Format with null-ls
			vim.lsp.buf.format({ async = false })
		end
		
		-- Create augroup for JSON-related autocommands
		local augroup = vim.api.nvim_create_augroup("JsonFormatting", { clear = true })
		
		-- Add format-on-save for JSON files
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			pattern = { "*.json", "*.jsonc" },
			callback = function(event)
				vim.lsp.buf.format({ 
					async = false,
					bufnr = event and event.buf or 0
				})
			end,
		})
		
		-- Set up keymaps for JSON files
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = { "json", "jsonc" },
			callback = function()
				-- Auto-fix command
				vim.keymap.set("n", "<leader>fa", function()
					fix_json_file()
				end, { buffer = true, desc = "Format JSON (fix)" })
				
				-- Standard format command
				vim.keymap.set("n", "<leader>fmt", function()
					fix_json_file()
				end, { buffer = true, desc = "Format JSON" })
				
				-- Diagnostic navigation
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = true })
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = true })
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = true })
			end,
		})
	end,
}
