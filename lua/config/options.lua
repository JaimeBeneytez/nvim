local o = vim.opt

o.number = true
o.showcmd = true -- autocmd
o.ruler = true -- show cursos position
o.encoding = "utf8" -- encooding
o.scrolloff = 10 -- scrollpadding
o.wrap = false -- avoid line wrapping
o.tabstop = 2 -- tab spaces
o.shiftwidth = 2 -- indent inside block
o.backspace = [[indent,eol,start]] -- backspace throughh everythiing
o.hlsearch = true -- search:  highlight search results
o.incsearch = true -- search:  incremental search
o.ignorecase = true -- search:  case insensitive while searching
o.smartcase = true -- search:  exception for the search insensitive whe the word contains an uppercase
o.shell = [[/bin/zsh]] -- shell
o.clipboard = [[unnamed]] -- clipboard: copy from vim to the OS and from the OS to vim
o.swapfile = false -- Disable swap files, let git do the work
o.history = 200 -- history: level
o.visualbell = true -- visual flash
o.iskeyword:remove(".")
o.wildignore:append({ -- ignore files
	"*.swp",
	"*.bak",
	"*.pyc",
	"*.class",
	"*.lock",
	"*/tmp/*",
	"*.so",
	"*.zip",
	".DS_Store",
	"*/temp/*",
	"*/backup/*",
	"*/log/*",
	"*.log",
	"**/node_modules/**",
})

vim.diagnostic.config({
	virtual_text = false, -- Disable inline messages
	signs = true, -- Keep signs in the gutter
	underline = true, -- Keep underline for diagnostics
	update_in_insert = false, -- Update diagnostics only on save or Normal mode
	severity_sort = true, -- Sort diagnostics by severity
})
