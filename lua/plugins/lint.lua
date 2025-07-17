return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			json = { "jsonlint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Fast fix current line using eslint_d
		local function fix_current_line()
			local filetype = vim.bo.filetype
			-- Only run on JavaScript/TypeScript files
			if filetype == "typescript" or filetype == "typescriptreact" or
			   filetype == "javascript" or filetype == "javascriptreact" then
				-- Direct use of eslint_d to fix current line/file
				local bufnr = vim.api.nvim_get_current_buf()
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				
				-- Save file first to ensure eslint_d has latest content
				if vim.bo.modified then
					vim.cmd("silent write")
				end
				
				-- Run eslint_d directly for fastest performance
				local cmd = string.format("eslint_d --fix '%s'", bufname)
				local result = vim.fn.system(cmd)
				
				-- Reload the buffer to see changes
				vim.cmd("edit")
				
				if vim.v.shell_error == 0 then
					vim.notify("Fixed with eslint_d", vim.log.levels.INFO)
					return
				end
				
				-- Fallback to LSP code actions
				vim.lsp.buf.code_action({
					context = {
						only = { "source.fixAll.eslint" }
					},
					apply = true,
				})
			end
		end
		
		-- Direct eslint_d fix command - doesn't use code actions at all
		local function eslint_d_fix_file()
			-- Get current buffer info
			local bufnr = vim.api.nvim_get_current_buf()
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			
			-- Save first if needed
			if vim.bo.modified then
				vim.cmd("silent write")
			end
			
			-- Run eslint_d directly on the file
			vim.notify("Fixing with eslint_d...", vim.log.levels.INFO)
			local cmd = string.format("eslint_d --fix '%s'", bufname)
			local result = vim.fn.system(cmd)
			
			-- Reload the buffer to see changes
			vim.cmd("edit")
			vim.notify("Fixed with eslint_d", vim.log.levels.INFO)
			return true
		end
		
		-- Auto-fix all functionality
		local function fix_all()
			local filetype = vim.bo.filetype

			-- Handle TypeScript/JavaScript with eslint_d directly
			if filetype == "typescript" or filetype == "typescriptreact" or
			   filetype == "javascript" or filetype == "javascriptreact" then
				-- Use our direct eslint_d command
				eslint_d_fix_file()
				return
			-- For JSON files, custom handling is done in json-utils.lua
			-- <leader>fa and <leader>fmt are directly mapped there
			elseif filetype == "json" or filetype == "jsonc" then
				-- For backward compatibility, try to call jq directly
				local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
				local text = table.concat(content, "\n")
				
				-- Use jq to format JSON content
				local formatted, error_msg = vim.fn.system("jq --indent 2 .", text)
				
				if vim.v.shell_error == 0 and formatted then
					local lines = vim.split(formatted, "\n")
					-- Remove the last empty line if present
					if lines[#lines] == "" then
						table.remove(lines, #lines)
					end
					vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
				end
				return
			end

			-- Fallback to LSP code actions for any filetype
			vim.lsp.buf.code_action({
				filter = function(a)
					return a.kind and string.find(a.kind, "quickfix") or
					      (a.title and a.title:find("Fix"))
				end,
				apply = true
			})
		end

		-- Set up file type specific keybindings for eslint_d
		local eslint_augroup = vim.api.nvim_create_augroup("eslint_autofix", { clear = true })
		
		-- Create file type specific autofix keybindings
		vim.api.nvim_create_autocmd("FileType", {
			group = eslint_augroup,
			pattern = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
			callback = function()
				-- Fast keystroke fix for current line
				vim.keymap.set("n", "<leader>f", fix_current_line, { 
					buffer = true, 
					desc = "Quick fix current line with eslint_d" 
				})
				
				-- Commented out buffer-local <leader>fa keybinding as requested by the user
			end,
		})
		
		-- Global keymaps
		-- Linting
		vim.keymap.set("n", "<leader>lint", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		-- Function to fix eslint issues in current file (for use internally)
		local function run_eslint_fix()
			local bufname = vim.api.nvim_buf_get_name(0)
			
			-- Save file first
			if vim.bo.modified then
				vim.cmd("silent write")
			end
			
			-- Run eslint_d
			local cmd = string.format("eslint_d --fix '%s'", bufname)
			local result = vim.fn.system(cmd)
			
			-- Reload the buffer
			vim.cmd("edit")
		end
		
		-- Commented out the global <leader>fa keybinding
		-- We're leaving it out as requested by the user
		
		-- Navigation keymaps for diagnostics
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic details" })
	end,
}
