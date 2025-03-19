return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "haydenmeade/neotest-jest",
  },
  config = function()
    local neotest = require("neotest")

    -- Function to create and show terminal
    local function show_term_with_command(cmd)
      -- Store current window
      local current_win = vim.api.nvim_get_current_win()
      
      -- Close existing terminal if any
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == 'terminal' then
          vim.api.nvim_win_close(win, true)
        end
      end
      
      -- Create new split and terminal
      vim.cmd('botright 15new')
      vim.cmd('terminal ' .. cmd)
      
      -- Configure terminal
      local buf = vim.api.nvim_get_current_buf()
      vim.bo[buf].buflisted = false
      vim.bo[buf].modifiable = false
      vim.wo.number = false
      vim.wo.relativenumber = false
      
      -- Return to original window
      vim.api.nvim_set_current_win(current_win)
    end

    local jest_adapter = require("neotest-jest")({
      jestCommand = "jest",
      env = { CI = true },
      cwd = function()
        return vim.fn.getcwd()
      end,
      strategy = function(cmd)
        show_term_with_command(table.concat(cmd, " "))
        return {
          stop = function() end
        }
      end
    })

    neotest.setup({
      adapters = { jest_adapter },
      discovery = {
        enabled = true,
      },
      output = {
        enabled = false,
        open_on_run = false,
      },
      status = {
        enabled = true,
        virtual_text = true,
        signs = true,
      },
      floating = {
        enabled = false,
      },
      summary = {
        enabled = false,
      }
    })

    -- Keybindings for Neotest
    local km = vim.keymap
    km.set("n", "<leader>tt", function()
      neotest.run.run()
    end, { desc = "Run test under cursor" })
    
    km.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run tests in current file" })
    
    km.set("n", "[t", neotest.jump.prev, { desc = "Jump to previous test" })
    km.set("n", "]t", neotest.jump.next, { desc = "Jump to next test" })
  end,
}
