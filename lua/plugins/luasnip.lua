return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	config = function()
		local snipmateLoader = require("luasnip.loaders.from_snipmate")

		snipmateLoader.load({ paths = "~/.config/nvim/lua/snippets" })
		snipmateLoader.lazy_load()

		local luasnip = require("luasnip")

		local unlinkgrp = vim.api.nvim_create_augroup(
			'UnlinkSnippetOnModeChange',
			{ clear = true }
		)

		vim.api.nvim_create_autocmd('ModeChanged', {
			group = unlinkgrp,
			pattern = { 's:n', 'i:*' },
			desc = 'Forget the current snippet when leaving the insert mode',
			callback = function(evt)
				if
					luasnip.session
					and luasnip.session.current_nodes[evt.buf]
					and not luasnip.session.jump_active
				then
					luasnip.unlink_current()
				end
			end,
		})

		vim.keymap.set({ "i" }, "<C-j>", function() luasnip.expand() end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-j>", function() luasnip.jump(1) end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-k>", function() luasnip.jump(-1) end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-i>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, { silent = true })
	end
}
