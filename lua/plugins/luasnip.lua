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
	end
}
